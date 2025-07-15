package bbluv.code.day8api.service;

import bbluv.code.day8api.entitties.Department;
import bbluv.code.day8api.repository.DepartmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DepartmentServiceImp implements IDepartmentService {

    @Autowired
    DepartmentRepository departmentRepository;

    @Override
    public void addDepartment(Department department) {
        departmentRepository.save(department);
    }

    @Override
    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }
}
