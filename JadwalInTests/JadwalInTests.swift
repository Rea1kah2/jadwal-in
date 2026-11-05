import XCTest
@testable import JadwalIn

final class JadwalInTests: XCTestCase {
    
    func testDayOfWeekConversion() {
        var components = DateComponents()
        components.year = 2026
        components.month = 11
        components.day = 2 // Monday (Senin)
        let calendar = Calendar.current
        guard let mondayDate = calendar.date(from: components) else {
            XCTFail("Failed to create date")
            return
        }
        
        let day = DayOfWeek.from(date: mondayDate)
        XCTAssertEqual(day, .monday)
        XCTAssertEqual(day.localizedName, "Senin")
    }
    
    func testCourseTimeRangeFormatted() {
        let course = Course(
            name: "Algoritma",
            code: "IF2101",
            startTime: "08:00",
            endTime: "10:30",
            colorHex: "1E3A8A"
        )
        XCTAssertEqual(course.timeRangeFormatted, "08:00 - 10:30")
        XCTAssertEqual(course.code, "IF2101")
    }
    
    func testAssignmentUrgencyLevels() {
        let now = Date()
        let cal = Calendar.current
        let courseId = UUID()
        
        // Critical: +10 hours
        let criticalDue = cal.date(byAdding: .hour, value: 10, to: now)!
        let criticalTask = Assignment(courseId: courseId, title: "Tugas 1", dueDate: criticalDue)
        XCTAssertEqual(criticalTask.urgency, .critical)
        
        // Approaching: +48 hours (2 days)
        let approachingDue = cal.date(byAdding: .day, value: 2, to: now)!
        let approachingTask = Assignment(courseId: courseId, title: "Tugas 2", dueDate: approachingDue)
        XCTAssertEqual(approachingTask.urgency, .approaching)
        
        // Upcoming: +5 days
        let upcomingDue = cal.date(byAdding: .day, value: 5, to: now)!
        let upcomingTask = Assignment(courseId: courseId, title: "Tugas 3", dueDate: upcomingDue)
        XCTAssertEqual(upcomingTask.urgency, .upcoming)
    }
    
    func testScheduleStoreCourseOperations() {
        let store = ScheduleStore()
        let initialCount = store.courses.count
        
        let newCourse = Course(
            name: "Kecerdasan Buatan",
            code: "IF3101",
            dayOfWeek: .tuesday,
            startTime: "13:00",
            endTime: "15:00"
        )
        
        store.addCourse(newCourse)
        XCTAssertEqual(store.courses.count, initialCount + 1)
        
        let coursesTuesday = store.coursesFor(day: .tuesday)
        XCTAssertTrue(coursesTuesday.contains(where: { $0.id == newCourse.id }))
        
        // Clean up
        store.deleteCourse(id: newCourse.id)
        XCTAssertEqual(store.courses.count, initialCount)
    }
    
    func testAssignmentSortingByDueDate() {
        let store = ScheduleStore()
        let now = Date()
        let cal = Calendar.current
        let courseId = store.courses.first?.id ?? UUID()
        
        let laterTask = Assignment(
            courseId: courseId,
            title: "Tugas Jauh",
            dueDate: cal.date(byAdding: .day, value: 10, to: now)!
        )
        let earlierTask = Assignment(
            courseId: courseId,
            title: "Tugas Dekat",
            dueDate: cal.date(byAdding: .hour, value: 2, to: now)!
        )
        
        store.addAssignment(laterTask)
        store.addAssignment(earlierTask)
        
        let active = store.activeAssignments
        guard let firstIdx = active.firstIndex(where: { $0.id == earlierTask.id }),
              let secondIdx = active.firstIndex(where: { $0.id == laterTask.id }) else {
            XCTFail("Tasks not found in active list")
            return
        }
        
        XCTAssertTrue(firstIdx < secondIdx, "Earlier due date must appear before later due date")
        
        // Clean up
        store.deleteAssignment(id: laterTask.id)
        store.deleteAssignment(id: earlierTask.id)
    }
}
