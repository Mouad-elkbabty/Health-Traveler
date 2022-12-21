<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cabinet.xsl
    Created on : 9 novembre 2022, 09:30
    Author     : grangeq
    Description:
        Purpose of transformation follows.
-->

<xs:stylesheet xmlns:xs="http://www.w3.org/1999/XSL/Transform" version="1.0"
               xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
               xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
               xmlns="http://www.w3.org/1999/xhtml">
    <xs:output method="html"/>
    <!-- cette variable servira pour faire des espaces -->
    <xs:variable name="espace" select="' '"/>
    
    <!-- Selection de l'infirmière -->
    <xs:param name="destinedId" select="001"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xs:template match="/">
        <html>
            <head>
                <title>Visites patients</title>
                <!-- fiche de style et js -->
                <link rel="stylesheet" href="../css/stylesCabinet.css" />
                <script type="text/javascript" src="../js/buttonScript.js"/>
            </head>
            <body>
                <div>
                    <p>Bonjour,
                        <!-- Recupère le prenom de l'infirmier dont l' id est passé en paramètre dans destinedId -->
                        <xs:value-of select="//cab:infirmiers/cab:infirmier[@id=$destinedId]/cab:prénom/text()"/>
                    </p> 
                    <br/>
                    <p>Aujourd'hui, vous avez 
                        <!-- Recupère le nombre de patients de l'infirmier dont l'id est passé en paramètre dans destinedId -->
                        <xs:value-of select="count(//cab:patients/cab:patient/cab:visite[@intervenant=$destinedId])"/>
                        patients</p>
                    <h1> Actes à réaliser :</h1>
                    <xs:apply-templates select="//cab:patients/cab:patient[./cab:visite/@intervenant=$destinedId]"/>
                </div>
            </body>
        </html>
    </xs:template>
    
    
    <!-- Template pour récupérer les noms des patients ,leurs adresses, les soins -->
    <!--
           
    -->
    <xs:template match="cab:patient">
        <!-- nom patient -->
        <p>Nom : <xs:value-of select="./cab:nom[../cab:visite/@intervenant=$destinedId]" /></p>
        
        <!-- adresse patient : à améliorer (ambiguité entre etage et numero !) -->
        <p>Adresse : 
            <xs:value-of select="cab:adresse/cab:numéro"/> 
            <xs:value-of select="$espace"/> 
            <xs:value-of select="cab:adresse/cab:rue"/>, 
            <xs:value-of select="$espace"/> 
            <xs:value-of select="cab:adresse/cab:codePostal"/>
            <xs:value-of select="$espace"/>
            <xs:value-of select="cab:adresse/cab:ville"/>
        </p>
        
        
        <!-- liste des soins à effectuer-->
        <p>Soins : <xs:apply-templates select="./cab:visite[./@intervenant=$destinedId]/cab:acte"/></p>
        
        <!-- bouttons pour la facture :  /!\ ne fait rien /!\  -->
        <xs:element name="input">
            <xs:attribute name="type">Submit</xs:attribute>
            <xs:attribute name="value">Facture</xs:attribute>
            <xs:attribute name="onclick">
                openFacture('<xs:value-of select="cab:prénom"/>',
                '<xs:value-of select="cab:nom"/>',
                '<xs:apply-templates select="./cab:patients/cab:patient/cab:visite[@intervenant=$destinedId]"/>')
            </xs:attribute>
        </xs:element>
        <br/>
        <br/>
        
    </xs:template>
    
    <!-- Permet l'affichage des différents soins -->
    <xs:template match="cab:acte">
        <xs:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
        <xs:variable name="idActe" select="./@id"/>
        <xs:value-of select="$actes/act:actes/act:acte[@id=$idActe]"/>
    </xs:template>
   

    
</xs:stylesheet>
