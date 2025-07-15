package bbluv.code.day8api.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bbluv.code.day8api.entitties.Employee;
import bbluv.code.day8api.repository.EmployeeRepository;
@Service
public class EmployeeServiceImp implements IEmployeeService {

    // Autowired EmployeeRepository employeeRepository;
    @Autowired
    private EmployeeRepository employeeRepository;

    @Override
    public List<Employee> getAllEmployees() {
        // Implementation for retrieving all employees
        return employeeRepository.findAll(); // Assuming employeeRepository is properly set up
    }

    @Override
    public Employee getEmployeeByCode(String code) {
        // Implementation for retrieving an employee by code
        return employeeRepository.findEmployeeByCode(code); // Assuming employeeRepository is properly set up
    }

    @Override
    public List<Employee> getEmployeeByName(String name) {
        // Implementation for retrieving employees by name
        return employeeRepository.findEmployeeByName(name); // Assuming employeeRepository is properly set up
    }

    @Override
    public void addEmployee(Employee employee) {
        // Check if employee with same code already exists
        Employee existingEmployee = getEmployeeByCode(employee.getCode());
        if (existingEmployee != null) {
            throw new RuntimeException("Employee with code " + employee.getCode() + " already exists");
        }
        // Implementation for adding a new employee
        employeeRepository.save(employee); // Save the employee using the repository
    }

    @Override
    public void updateEmployee(String code, Employee employee) {
        // Implementation for updating an existing employee
        Employee existingEmployee = getEmployeeByCode(code);
        if (existingEmployee != null) {
            // Update fields as necessary
            if (employee.getName() != null) {
                existingEmployee.setName(employee.getName());
            }
            if (employee.getDepartment() != null) {
                existingEmployee.setDepartment(employee.getDepartment());
            }
            if (employee.getPassword() != null && !employee.getPassword().trim().isEmpty()) {
                existingEmployee.setPassword(employee.getPassword());
            }
            if (employee.getGender() != 0) {
                existingEmployee.setGender(employee.getGender());
            }
            // Save the updated employee
            employeeRepository.save(existingEmployee);
        } else {
            throw new RuntimeException("Employee with code " + code + " not found");
        }
    }

    @Override
    public void deleteEmployee(String code) {
        // Implementation for deleting an employee by code
        Employee employee = getEmployeeByCode(code);
        if (employee != null) {
            employeeRepository.delete(employee); // Delete the employee using the repository
        } else {
            throw new RuntimeException("Employee with code " + code + " not found");
        }
    }

    @Override
    public Employee checkLogin(String code, String password) {
        // Implementation for checking login credentials
        return employeeRepository.checkLogin(code, password); // Assuming employeeRepository is properly set up
    }
}
