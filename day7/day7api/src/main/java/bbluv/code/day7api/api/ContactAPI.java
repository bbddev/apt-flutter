package bbluv.code.day7api.api;

import bbluv.code.day7api.entities.Contact;
import bbluv.code.day7api.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contacts")
public class ContactAPI {
    @Autowired
    private ContactService contactService;

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
   public List<Contact> get(){
        return contactService.getAllContacts();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Contact create(@RequestBody Contact contact) {
        return contactService.saveContact(contact);
    }
    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Contact getById(@PathVariable int id) {
        return contactService.getContactById(id);
    }
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable int id) {
        contactService.deleteContact(id);
    }
    @PutMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Contact update(@PathVariable int id, @RequestBody Contact contact) {
        Contact existingContact = contactService.getContactById(id);
        if (existingContact != null) {
            existingContact.setName(contact.getName());
            existingContact.setPhone(contact.getPhone());
            return contactService.saveContact(existingContact);
        }
        return null; // or throw an exception
    }

    @GetMapping("/search")
    @ResponseStatus(HttpStatus.OK)
    public List<Contact> searchByName(@RequestParam String name) {
        return contactService.searchContactsByName(name);
    }
}
