package bbluv.code.day8api.service;

import bbluv.code.day8api.entitties.Employee;

import java.util.List;

public interface IEmployeeService {
    List<Employee> getAllEmployees();
    Employee getEmployeeByCode(String code);
    List<Employee> getEmployeeByName(String name);
    void addEmployee(Employee employee);
    void updateEmployee(String code, Employee employee);
    void deleteEmployee(String code);
    Employee checkLogin(String code, String password);
}
