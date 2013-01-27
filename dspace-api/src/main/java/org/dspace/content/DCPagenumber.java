/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content;

import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.*;

import org.apache.log4j.Logger;

//Classe di supporto per il tipo DC Pagenumber 
public class DCPagenumber
{
    /** Logger */
    private static Logger log = Logger.getLogger(DCPagenumber.class);

   private Integer startPage = -1;
   private Integer endPage = -1;

    
   
    public DCPagenumber(Integer startPage, Integer endPage)
    {
        this.startPage = startPage;
        this.endPage = endPage;
    }
    
    public DCPagenumber(String fromDC){
    	if ((fromDC == null) || fromDC.equals(""))
        {
            this.startPage = -1;
            this.endPage = -1;
        }else{
        	int indiceseparatore = fromDC.indexOf('-');
        	String sStartPage = fromDC.substring(0, indiceseparatore);
        	try{
        		this.startPage = Integer.parseInt(sStartPage);
        	}catch(Exception ex){
        		this.startPage = -1;
        	}
        	String sEndPage = fromDC.substring(indiceseparatore+1, fromDC.length());
        	try{
        		this.endPage = Integer.parseInt(sEndPage);
        	}catch(Exception ex){
        		this.endPage = -1;
        	}	
        }
    	
    }


    
    public String toString()
    {
       String ret = "";
       String sStartPage = "";
       String sEndPage = "";
      
      if(this.getStartPage().equals(-1)){
    	  sStartPage = "";
      }else{
    	  sStartPage = this.getStartPage().toString();
      }
      if(this.getEndPage().equals(-1)){
    	  sEndPage = "";
      }else{
    	  sEndPage = this.getEndPage().toString();
      }
      
      if(this.getStartPage().equals(-1) && this.getEndPage().equals(-1)){
    	  ret = "";
      }else{
    	  ret = sStartPage + "-" + sEndPage;
      }
       return ret;
    }


	public Integer getStartPage() {
		return startPage;
	}


	public void setStartPage(Integer startPage) {
		this.startPage = startPage;
	}


	public Integer getEndPage() {
		return endPage;
	}


	public void setEndPage(Integer endPage) {
		this.endPage = endPage;
	}

    
    

    
}
