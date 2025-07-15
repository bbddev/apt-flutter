package bbluv.code.day8api.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import bbluv.code.day8api.dto.LoginRequest;
import bbluv.code.day8api.entitties.Department;
import bbluv.code.day8api.entitties.Employee;
import bbluv.code.day8api.service.IDepartmentService;
import bbluv.code.day8api.service.IEmployeeService;

@RestController
@RequestMapping("/api")
public class HomeController {
    @Autowired
    private IDepartmentService departmentService;

    @Autowired
    private IEmployeeService employeeService;

    @GetMapping("/department")
    @ResponseStatus(HttpStatus.OK)
    public List<Department> getAllDepartments() {
        return departmentService.getAllDepartments();
    }

    @PostMapping("/department")
    @ResponseStatus(HttpStatus.CREATED)
    public void addDepartment(@RequestBody Department department) {
        departmentService.addDepartment(department);
    }

    // Employee APIs
    @GetMapping("/employee")
    @ResponseStatus(HttpStatus.OK)
    public List<Employee> getAllEmployees() {
        return employeeService.getAllEmployees();
    }

    @PostMapping("/employee")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Employee> addEmployee(@RequestBody Employee employee) {
        if (employee == null || employee.getCode() == null || employee.getName() == null || employee.getDepartment() == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        try {
            employeeService.addEmployee(employee);
            return ResponseEntity.status(HttpStatus.CREATED).body(employee);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/employee/{code}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Employee> getEmployeeByCode(@PathVariable String code) {
        Employee employee = employeeService.getEmployeeByCode(code);
        if (employee == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(employee);
    }

    @GetMapping("/employee/name/{name}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<List<Employee>> getEmployeeByName(@PathVariable String name) {
        if (name == null || name.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        try {
            List<Employee> employees = employeeService.getEmployeeByName(name);
            return ResponseEntity.ok(employees);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/employee/{code}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Employee> updateEmployee(@PathVariable String code, @RequestBody Employee employee) {
        if (code == null || code.trim().isEmpty() || employee == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        try {
            Employee existingEmployee = employeeService.getEmployeeByCode(code);
            if (existingEmployee == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            employeeService.updateEmployee(code, employee);
            Employee updatedEmployee = employeeService.getEmployeeByCode(code);
            return ResponseEntity.ok(updatedEmployee);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @DeleteMapping("/employee/{code}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public ResponseEntity<Void> deleteEmployee(@PathVariable String code) {
        if (code == null || code.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        try {
            Employee existingEmployee = employeeService.getEmployeeByCode(code);
            if (existingEmployee == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            employeeService.deleteEmployee(code);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/login")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Employee> checkLogin(@RequestParam(required = false) String code, 
                                               @RequestParam(required = false) String password,
                                               @RequestBody(required = false) LoginRequest loginRequest) {
        String employeeCode = null;
        String employeePassword = null;
        
        // Try to get credentials from request parameters first
        if (code != null && password != null) {
            employeeCode = code;
            employeePassword = password;
        }
        // If not found in params, try from request body
        else if (loginRequest != null) {
            employeeCode = loginRequest.getCode();
            employeePassword = loginRequest.getPassword();
        }
        
        // Validate that we have the required credentials
        if (employeeCode == null || employeeCode.trim().isEmpty() || 
            employeePassword == null || employeePassword.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        
        try {
            Employee employee = employeeService.checkLogin(employeeCode, employeePassword);
            if (employee == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            return ResponseEntity.ok(employee);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/login/json")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Employee> checkLoginJson(@RequestBody LoginRequest loginRequest) {
        if (loginRequest == null || 
            loginRequest.getCode() == null || loginRequest.getCode().trim().isEmpty() ||
            loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        
        try {
            Employee employee = employeeService.checkLogin(loginRequest.getCode(), loginRequest.getPassword());
            if (employee == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            return ResponseEntity.ok(employee);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
