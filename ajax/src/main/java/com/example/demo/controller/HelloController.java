package com.example.demo.controller;

import com.example.demo.Member;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "hello";
    }

    @ResponseBody
    @PostMapping("/data")
    public Member data(@RequestBody Member member) {
        return member;
    }

}
