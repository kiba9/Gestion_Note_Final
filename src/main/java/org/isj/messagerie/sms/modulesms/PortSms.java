/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.sms.modulesms;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Work Station
 */
public class PortSms {
    private String nomComPort;
    private List<Integer>tabFrequence;
    private boolean frequencesOK;

    public PortSms() {
    }

    public String getNomComPort() {
        return nomComPort;
    }

    public void setNomComPort(String nomComPort) {
        this.nomComPort = nomComPort;
    }

    public List<Integer> getTabFrequence() {
        return tabFrequence;
    }

    public void setTabFrequence(List<Integer> tabFrequence) {
        this.tabFrequence = tabFrequence;
    }

    public boolean isFrequencesOK() {
        return frequencesOK;
    }

    public void setFrequencesOK(boolean frequencesOK) {
        this.frequencesOK = frequencesOK;
    }

    @Override
    public String toString() {
        return "PortSms{" + "nomComPort=" + nomComPort + ", tabFrequence=" + tabFrequence + ", frequencesOK=" + frequencesOK + '}';
    }
    
}
