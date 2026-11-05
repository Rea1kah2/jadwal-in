import Foundation
import SwiftUI
import Combine

public final class ScheduleStore: ObservableObject {
    @Published public var courses: [Course] = []
    @Published public var assignments: [Assignment] = []
    
    private let fileName = "jadwalin_store.json"
    
    public init() {
        loadData()
    }
    
    // MARK: - File Paths
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var storeFileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - Store Envelope
    private struct StoreEnvelope: Codable {
        var courses: [Course]
        var assignments: [Assignment]
    }
    
    // MARK: - Persistence
    public func loadData() {
        if FileManager.default.fileExists(atPath: storeFileURL.path) {
            do {
                let data = try Data(contentsOf: storeFileURL)
                let decoded = try JSONDecoder().decode(StoreEnvelope.self, from: data)
                self.courses = decoded.courses
                self.assignments = decoded.assignments
            } catch {
                print("Error loading Jadwal-In data: \(error). Falling back to sample data.")
                loadSampleData()
            }
        } else {
            loadSampleData()
        }
    }
    
    public func saveData() {
        do {
            let envelope = StoreEnvelope(courses: courses, assignments: assignments)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(envelope)
            try data.write(to: storeFileURL, options: .atomic)
        } catch {
            print("Failed to save Jadwal-In data: \(error)")
        }
    }
    
    public func loadSampleData() {
        self.courses = Course.sampleCourses
        self.assignments = Assignment.sampleAssignments(for: self.courses)
        saveData()
    }
    
    public func clearAllData() {
        self.courses = []
        self.assignments = []
        saveData()
    }
    
    // MARK: - Course Operations
    public func addCourse(_ course: Course) {
        courses.append(course)
        sortCourses()
        saveData()
    }
    
    public func updateCourse(_ course: Course) {
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses[index] = course
            sortCourses()
            saveData()
        }
    }
    
    public func deleteCourse(id: UUID) {
        courses.removeAll { $0.id == id }
        // Clean up or keep assignments with orphan safety
        assignments.removeAll { $0.courseId == id }
        saveData()
    }
    
    private func sortCourses() {
        courses.sort {
            if $0.dayOfWeek.rawValue == $1.dayOfWeek.rawValue {
                return $0.startTime < $1.startTime
            }
            return $0.dayOfWeek.rawValue < $1.dayOfWeek.rawValue
        }
    }
    
    public func course(for id: UUID) -> Course? {
        courses.first { $0.id == id }
    }
    
    public func coursesFor(day: DayOfWeek) -> [Course] {
        courses
            .filter { $0.dayOfWeek == day }
            .sorted { $0.startTime < $1.startTime }
    }
    
    // MARK: - Assignment Operations
    public func addAssignment(_ assignment: Assignment) {
        assignments.append(assignment)
        sortAssignments()
        saveData()
    }
    
    public func updateAssignment(_ assignment: Assignment) {
        if let index = assignments.firstIndex(where: { $0.id == assignment.id }) {
            assignments[index] = assignment
            sortAssignments()
            saveData()
        }
    }
    
    public func deleteAssignment(id: UUID) {
        assignments.removeAll { $0.id == id }
        saveData()
    }
    
    public func toggleAssignmentCompletion(id: UUID) {
        if let index = assignments.firstIndex(where: { $0.id == id }) {
            assignments[index].isCompleted.toggle()
            sortAssignments()
            saveData()
        }
    }
    
    private func sortAssignments() {
        assignments.sort {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted && $1.isCompleted
            }
            return $0.dueDate < $1.dueDate
        }
    }
    
    // MARK: - Query Filters
    public var activeAssignments: [Assignment] {
        assignments
            .filter { !$0.isCompleted }
            .sorted { $0.dueDate < $1.dueDate }
    }
    
    public var completedAssignments: [Assignment] {
        assignments
            .filter { $0.isCompleted }
            .sorted { $0.dueDate > $1.dueDate }
    }
    
    public func urgentAssignments(limit: Int = 3) -> [Assignment] {
        activeAssignments
            .filter { $0.urgency == .critical || $0.urgency == .approaching }
            .prefix(limit)
            .map { $0 }
    }
}
