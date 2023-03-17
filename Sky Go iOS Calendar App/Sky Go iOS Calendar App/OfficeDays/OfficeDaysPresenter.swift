
import Foundation

protocol OfficeDaysPresenterDelegate: AnyObject{
    func reloadTableView (appointments:[Appointment])
    func togglePastButtonColour ()
    func toggleFutureButtonColour ()
}

class OfficeDaysPresenter {
    
    private let officeDaysModel:OfficeDaysModelProtocol
    private let calendar = Calendar.current
    private let today:Date
    
    init (officeDaysModel:OfficeDaysModelProtocol, today:Date = Date()) {
        self.officeDaysModel = officeDaysModel
        self.today = today
    }

    weak var delegate:OfficeDaysPresenterDelegate?
    
    var pastAppointments:[Appointment] = []
    var futureAppointments:[Appointment] = []
    
    private var dateFormatter = DateFormatter()
    
    func viewDidLoad () {
        officeDaysModel.setupAppointmentsListener(completion: {appointments in
            self.sortAppointments(appointmentsArray: appointments)
            self.delegate?.reloadTableView(appointments: self.futureAppointments)
        })
    }
    
    func pastButtonClicked () {
        self.delegate?.togglePastButtonColour()
        self.delegate?.reloadTableView(appointments: self.pastAppointments)
    }
    
    func futureButtonClicked () {
        self.delegate?.toggleFutureButtonColour()
        self.delegate?.reloadTableView(appointments: self.futureAppointments)
    }
    
    private func sortAppointments(appointmentsArray: [Appointment]) {
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let convertedAppointments = appointmentsArray.map {return ($0, dateFormatter.date(from: $0.date ))}
            .sorted { $0.1 ?? Date() < $1.1 ?? Date()}
            .map(\.0)
        
        self.pastAppointments = []
        self.futureAppointments = []
        
        convertedAppointments.forEach({appointment in
            let convertedDate = dateFormatter.date(from: appointment.date )
            let yesterday = addDays(date:self.today, days: -1)
            if convertedDate ?? Date() > yesterday {
                self.futureAppointments.append(appointment)
            } else {
                self.pastAppointments.append(appointment)
            }
        })
        
        
        self.pastAppointments = self.pastAppointments.map {return ($0, dateFormatter.date(from: $0.date ))}
            .sorted { $0.1 ?? Date() > $1.1 ?? Date()}
            .map(\.0)
    }
    
    private func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date) ?? Date()
    }
}
