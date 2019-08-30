package org.isj.metier.entites;

import org.junit.Test;

import static org.junit.Assert.*;

public class FiliereTest {

    @Test
    public void toString1() {
        Filiere t = new Filiere("agro","");
        String result= t.toString();
        assertEquals("agro",result);
    }
}
