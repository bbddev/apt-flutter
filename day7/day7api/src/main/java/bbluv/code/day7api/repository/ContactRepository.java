package bbluv.code.day7api.repository;

import bbluv.code.day7api.entities.Contact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ContactRepository extends JpaRepository<Contact, Integer>  {
    @Query("SELECT c FROM Contact c WHERE c.name LIKE %:name%")
    List<Contact> findByNameLike(String name);
}
