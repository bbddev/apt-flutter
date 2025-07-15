package bbluv.code.day7api.service;

import bbluv.code.day7api.entities.Contact;
import bbluv.code.day7api.repository.ContactRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactService {

    private final ContactRepository contactRepository;

    public ContactService(ContactRepository contactRepository) {
        this.contactRepository = contactRepository;
    }

    public List<Contact> getAllContacts() {
        return contactRepository.findAll();
    }

    public Contact saveContact(Contact contact) {
        return contactRepository.save(contact);
    }

    public Contact getContactById(int id) {
        return contactRepository.findById(id).orElse(null);
    }

    public void deleteContact(int id) {
        contactRepository.deleteById(id);
    }

    public List<Contact> findContactByNameLike(String name) {
        return contactRepository.findByNameLike(name);
    }
}
