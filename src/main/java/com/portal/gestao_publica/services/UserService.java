package com.portal.gestao_publica.services;

import com.portal.gestao_publica.dtos.PostUserRequestDTO;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User get(UUID id) {
        return userRepository.findById(id).orElseThrow();
    }

    public List<User> getAll() {
        return userRepository.findAll();
    }

    public User post(PostUserRequestDTO postUser) {
        User user = new User();
        user.setName(postUser.name());
        user.setEmail(postUser.email());
        user.setAddress(postUser.address());
        user.setEmail(postUser.email());
        user.setBirthDate(postUser.birthDate());
        user.setRole(postUser.role());
        user.setPassword(new BCryptPasswordEncoder().encode(postUser.password()));
        return userRepository.save(user);
    }

    public User patch(PostUserRequestDTO patchUser, UUID id) {
        User user = userRepository.findById(id).orElseThrow();

        user.setName(patchUser.name());
        user.setEmail(patchUser.email());
        user.setAddress(patchUser.address());
        user.setEmail(patchUser.email());
        user.setBirthDate(patchUser.birthDate());
        user.setRole(patchUser.role());
        if(!patchUser.password().isEmpty()) {
            user.setPassword(new BCryptPasswordEncoder().encode(patchUser.password()));
        }
        return userRepository.save(user);
    }
}
