package bbluv.code.day8api.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String code;
    private String password;
}
