package bbluv.code.day7api.entities;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "contact")
public class Contact {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;
    String name;
    String phone;
}
