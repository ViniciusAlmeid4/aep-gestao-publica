package com.portal.gestao_publica.services;

import com.portal.gestao_publica.dtos.LoginRequestDTO;
import com.portal.gestao_publica.dtos.LoginResponseDTO;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthService implements UserDetailsService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JWTService jwtService;

    @Override
    public UserDetails loadUserByUsername(String email) {
        User user = userRepository.findByEmail(email);
        if (user == null) throw new UsernameNotFoundException("User not found");
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(), user.getPassword(), List.of()
        );
    }

    public LoginResponseDTO login(LoginRequestDTO dto) {
        User user = userRepository.findByEmail(dto.email());
        if (user == null) throw new UsernameNotFoundException("User not found");

        if (!new BCryptPasswordEncoder().matches(dto.password(), user.getPassword()))
            throw new BadCredentialsException("Invalid password");

        String token = jwtService.generateToken(user);
        return new LoginResponseDTO(token);
    }
}
