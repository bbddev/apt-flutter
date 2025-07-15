package bbluv.code.day8api.repository;

import bbluv.code.day8api.entitties.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, String> {
    // Additional query methods can be defined here if needed
}
