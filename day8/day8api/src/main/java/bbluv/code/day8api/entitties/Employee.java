package bbluv.code.day8api.entitties;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "employees")
@Data
public class Employee {
    @Id
    private String code;
    private String name;
    private String password;
    private int gender;
    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    Department department;
}
