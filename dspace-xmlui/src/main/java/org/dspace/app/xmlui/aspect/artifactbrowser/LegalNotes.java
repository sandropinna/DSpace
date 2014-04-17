/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.artifactbrowser;

import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.xml.sax.SAXException;

/**
 * Create a simple legal notes page. 
 * 
 * 
 * @author Sandro Pinna
 */
public class LegalNotes extends AbstractDSpaceTransformer implements CacheableProcessingComponent
{
    /** language strings */
    private static final Message T_title =
        message("xmlui.ArtifactBrowser.LegalNotes.title");
    
    private static final Message T_dspace_home =
        message("xmlui.general.dspace_home");
    
    private static final Message T_trail = 
        message("xmlui.ArtifactBrowser.LegalNotes.trail");
    
    private static final Message T_head = 
        message("xmlui.ArtifactBrowser.LegalNotes.head");
    
    private static final Message T_para1 =  message("xmlui.ArtifactBrowser.LegalNotes.para1");
    private static final Message T_para2 =  message("xmlui.ArtifactBrowser.LegalNotes.para2");
    private static final Message T_para1b =  message("xmlui.ArtifactBrowser.LegalNotes.para1b");
    private static final Message T_para2b =  message("xmlui.ArtifactBrowser.LegalNotes.para2b");
    private static final Message T_para3 =  message("xmlui.ArtifactBrowser.LegalNotes.para3");
    private static final Message T_para4 = message("xmlui.ArtifactBrowser.LegalNotes.para4");
    private static final Message T_para5 = message("xmlui.ArtifactBrowser.LegalNotes.para5");
    private static final Message T_para6 = message("xmlui.ArtifactBrowser.LegalNotes.para6");
    private static final Message T_para7 = message("xmlui.ArtifactBrowser.LegalNotes.para7");
    private static final Message T_para8 = message("xmlui.ArtifactBrowser.LegalNotes.para8");
    private static final Message T_para9 = message("xmlui.ArtifactBrowser.LegalNotes.para9");
    private static final Message T_para10 = message("xmlui.ArtifactBrowser.LegalNotes.para10");
    private static final Message T_para11 = message("xmlui.ArtifactBrowser.LegalNotes.para11");
    private static final Message T_para12 = message("xmlui.ArtifactBrowser.LegalNotes.para12");
    private static final Message T_para13 = message("xmlui.ArtifactBrowser.LegalNotes.para13");
    private static final Message T_para14 = message("xmlui.ArtifactBrowser.LegalNotes.para14");
    private static final Message T_para15 = message("xmlui.ArtifactBrowser.LegalNotes.para15");
    private static final Message T_para16 = message("xmlui.ArtifactBrowser.LegalNotes.para16");

    private static final Message T_feedback_label =
        message("xmlui.ArtifactBrowser.Contact.feedback_label");
    
    private static final Message T_feedback_link =
        message("xmlui.ArtifactBrowser.Contact.feedback_link");
    
    private static final Message T_email = 
        message("xmlui.ArtifactBrowser.Contact.email");
    
    
    /**
     * Generate the unique caching key.
     * This key must be unique inside the space of this component.
     */
    public Serializable getKey() 
    {
       return "1";
    }

    /**
     * Generate the cache validity object.
     */
    public SourceValidity getValidity() 
    {
        return NOPValidity.SHARED_INSTANCE;
    }
    
    
    public void addPageMeta(PageMeta pageMeta) throws SAXException,
            WingException, UIException, SQLException, IOException,
            AuthorizeException
    {
        pageMeta.addMetadata("title").addContent(T_title);
       
        pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
        pageMeta.addTrail().addContent(T_trail);
    }

  
    public void addBody(Body body) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
        Division legalNotes = body.addDivision("contact","primary");
     
        legalNotes.setHead(T_head);
        
       /*
        String name = ConfigurationManager.getProperty("dspace.name");
        legalNotes.addPara(T_para1.parameterize(name));
        
        List list = legalNotes.addList("contact");
        
        list.addLabel(T_feedback_label);
        list.addItem().addXref(contextPath+"/feedback",T_feedback_link);
        
        list.addLabel(T_email);
        String email = ConfigurationManager.getProperty("feedback.recipient");
        list.addItem().addXref("mailto:"+email,email); 
        */
        legalNotes.addPara(T_para1);
        legalNotes.addPara(T_para2);
        legalNotes.addPara(T_para1b);
        legalNotes.addPara(T_para2b);
        legalNotes.addPara(T_para3);
        legalNotes.addPara(T_para4);
        legalNotes.addPara(T_para5);
        legalNotes.addPara(T_para6);
        legalNotes.addPara(T_para7);
        legalNotes.addPara(T_para8);
        legalNotes.addPara(T_para9);
        legalNotes.addPara(T_para10);
        legalNotes.addPara(T_para11);
        legalNotes.addPara(T_para12);
        legalNotes.addPara(T_para13);
        legalNotes.addPara(T_para14);
        legalNotes.addPara(T_para15);
        legalNotes.addPara(T_para16);
    }
}
