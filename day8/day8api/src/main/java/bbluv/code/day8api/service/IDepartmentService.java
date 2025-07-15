package bbluv.code.day8api.service;

import bbluv.code.day8api.entitties.Department;

import java.util.List;

public interface IDepartmentService {
    void addDepartment(Department department);
    List<Department> getAllDepartments();

}
