package bbluv.code.day8api.repository;

import bbluv.code.day8api.entitties.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, String> {
    @Query("SELECT e FROM Employee e WHERE e.code = :code AND e.password = :password")
    public Employee checkLogin(@Param("code") String code, @Param("password") String password);

    @Query("SELECT e FROM Employee e WHERE e.name LIKE %:name%")
    public List<Employee> findEmployeeByName(@Param("name") String name);

    @Query("SELECT e FROM Employee e WHERE e.code = :code")
    public Employee findEmployeeByCode(@Param("code") String code);
}
