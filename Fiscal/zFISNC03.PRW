#Include 'Totvs.ch'
#Include 'FWMVCDef.ch'
 


#DEFINE PREP_TAB_NOME 1
#DEFINE PREP_TAB_CAMPOS 2
#DEFINE PREP_TAB_OTEMP 3
#DEFINE PREP_TAB_MODEL 4
#DEFINE PREP_TAB_ESTR_VIEW 5





User Function MODEL_ABA()
    Local aParam     := PARAMIXB
    Local oObj
    Local cIdPonto  := ""
    Local cIdModel  := ""
    Local xRet      := .T.

    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]

        If cIdPonto == "BUTTONBAR" 
            xRet := {}
            If oObj:CSource == "FISA170"
                xRet := {{"Facilitador de NCM", "FACILITADOR", {||U_zFISNC03()}}}
            EndIf
            Return xRet
        EndIf
    EndIf

Return xRet




/*/{Protheus.doc} User Function zFISNC03
Tela para Marcação de dados - Autumn Code Maker
Função principal que cria uma interface MVC para Facilitar a configuração de Regras de NCM
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
USER Function zFISNC03()

    Local oModel
    Local oView

    Local aTamanho  := MsAdvSize()
    Local nJanLarg  := aTamanho[5]
    Local nJanAltu  := aTamanho[6]
    
    Local nIdx
    Local oTmp


    Private aEstrura := {}
    Private oDlgRegNcm

    PrepTabela()
    oModel   := Modelx()

    EstrView()
    oView    := Viewx()

    oView:SetModel(oModel)
    oModel:SetOperation(MODEL_OPERATION_INSERT)

    oView:setOperation(MODEL_OPERATION_INSERT)

    oView:EnableControlBar(.F.)
    oView:SetUseCursor(.F.)

    oView:EnableTitleView("X_FIELD_NCM","Parametros do Configurador")

    DEFINE MSDIALOG oDlgRegNcm TITLE 'Tela para Marcação de dados - Autumn Code Maker' ;
        FROM 000, 000  TO nJanAltu-20, nJanLarg-10 COLORS 0, 16777215 PIXEL

        oView:SetOwner(oDlgRegNcm)

        SetFunName("U_zFISNC03")
        oModel:cArgo[1][2] = "U_zFISNC03"
        oView:Activate()
        
    ACTIVATE MsDialog oDlgRegNcm CENTERED
  

    for nIdx := 1 to len(aEstrura)
        oTmp := aEstrura[nIdx,PREP_TAB_OTEMP]
        oTmp:Delete()
    next

Return



/*/{Protheus.doc} User Function PrepTabela
Montando Tabelas Temporarias e sua estrutura
Criando a array de estruturas

Array de estruturas, armazena as tabelas temporarias e sua estrutura
Utilizada para evitar um monte de variavel privada
Utilizada em toda a Rotina

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
/*/
Static Function PrepTabela()

    Local aFieldCFG := {}
    Local aGridNCM  := {}
    Local aGridALiq := {}
    Local aGridTrib := {}
    Local aGridMVA  := {}


    Local nPos

    // Tabela Configuracao **************************



    aAdd(aFieldCFG, {"X_TABKEY"  ,"kEY"      , "C",3,0,"@!"})

    aAdd(aFieldCFG, {"X_TABELA"     ,"Consid.Tabela."       , "C",1 ,0,"@!"})
    aAdd(aFieldCFG, {"X_FCEST"      ,"Consid.Cest."         , "C",1 ,0,"@!"})
    aAdd(aFieldCFG, {"X_FMVA"       ,"Consid.MVA - Aux 01"     , "C",1 ,0,"@!"})
    aAdd(aFieldCFG, {"X_IPI"        ,"Consid.IPI - Aux 02"     , "C",1 ,0,"@!"})
    aAdd(aFieldCFG, {"X_ABAS"       ,"Atualiza Abas"         , "C",1 ,0,"@!"})
    aAdd(aFieldCFG, {"X_DATAVG"     ,"Data Inic. Vigencia"         , "D",8 ,0,"@!"})



    aAdd(aFieldCFG, yObterSX3("F24_CDPROD"    ,"X_PRODE"     ,"Produto de"       ))
    aAdd(aFieldCFG, yObterSX3("F24_CDPROD"    ,"X_PROATE"    ,"Produto ate"      ))
    aAdd(aFieldCFG, yObterSX3("B1_GRUPO"      ,"X_GRBDE"     ,"Grupo Prod. de"   ))
    aAdd(aFieldCFG, yObterSX3("B1_GRUPO"      ,"X_GRBATE"    ,"Grupo Prod. ate"  ))
    aAdd(aFieldCFG, yObterSX3("B1_GRTRIB"     ,"X_TRIDE"     ,"Grupo Trib. de"   ))
    aAdd(aFieldCFG, yObterSX3("B1_GRTRIB"     ,"X_TRIATE"    ,"Grupo Trib. ate"  ))



    yAddEstrutura("X_FIELD_NCM",aFieldCFG,{{"X_TABKEY"}})

    // Tabela NCM ************************************


    aAdd(aGridNCM, {"Z_TABKEY"  ,"kEY"      , "C",3,0,"@!"})

    aAdd(aGridNCM, yObterSX3("CIS_CODNCM"   ,"Z_NCM"      ,"Cod. NCM"))
    aAdd(aGridNCM, yObterSX3("CIS_DESCR"    ,"Z_DESCR"    ,"Descricao"))
    aAdd(aGridNCM, yObterSX3("CIU_CEST"     ,"Z_CEST"     ,"Cod. CEST"))
    aAdd(aGridNCM, yObterSX3("CIU_MARGEM"   ,"Z_AUX01"     ,"Valor Aux01"))
    aAdd(aGridNCM, yObterSX3("CIU_MARGEM"   ,"Z_AUX02"     ,"Valor Aux02"))


    //aAdd(aGridNCM, {"Z_TABELA" ,"Consid.Tabela."       , "C",1 ,0,"@!"})


        nPos := aScan(aGridNCM,{ |x| x[1] == "Z_NCM" })
        aGridNCM[nPos,6] := "@R 9999.99.99"

    yAddEstrutura("X_GRID_NCM",aGridNCM,{{"Z_TABKEY","Z_NCM"}})


    // **************  Tabela Estados ***********************/

    aAdd(aGridALiq, {"Y_TABKEY",    "kEY"  ,  "C",  3,  0,  "@!"})
    aAdd(aGridALiq, {"Y_ITEM"  ,    "Item" ,  "C",  4,  0,  "@!"})

    aAdd(aGridALiq, yObterSX3("CIU_UFORI"    ,"Y_UFORI"   ))
    aAdd(aGridALiq, yObterSX3("CIU_UFDEST"   ,"Y_UFDEST"  ))
    aAdd(aGridALiq, yObterSX3("CIU_ORIGEM"   ,"Y_ORIGEM"  ))
    aAdd(aGridALiq, yObterSX3("CIU_ALIQTR"   ,"Y_ALIQTR"  ,"Aba Aliq"))
    //aAdd(aFldGridNCM, yObterSX3("CIU_ALIQTR"   ,"ZXZ_ALIQDS"  ,"Aliq DIFAL UF Dest." ))
    aAdd(aGridALiq, {"Y_TBNCM"  ,    "Tabela NCM" ,  "C",  1,  0,  "@!"})


    yAddEstrutura("X_GRID_ALIQ",aGridALiq,{{"Y_TABKEY","Y_ITEM"}})


    // **************  Tabela MVA ***********************/

    aAdd(aGridMVA, {"M_TABKEY",    "kEY"  ,  "C",  3,  0,  "@!"})
    aAdd(aGridMVA, {"M_ITEM"  ,    "Item" ,  "C",  4,  0,  "@!"})

    aAdd(aGridMVA, yObterSX3("CIU_UFORI"    ,"M_UFORI"   ))
    aAdd(aGridMVA, yObterSX3("CIU_UFDEST"   ,"M_UFDEST"  ))
    aAdd(aGridMVA, yObterSX3("CIU_ORIGEM"   ,"M_ORIGEM"  ))
    aAdd(aGridMVA, yObterSX3("CIU_MARGEM"   ,"M_MVA"     ,"MVA"))
    aAdd(aGridMVA, yObterSX3("CIU_MVAAUX"   ,"M_MVAAUX"  ,"MVA Aux"))

    aAdd(aGridMVA, {"M_TBNCM"  ,    "Tabela NCM" ,  "C",  1,  0,  "@!"})

    yAddEstrutura("X_GRID_MVA",aGridMVA,{{"M_TABKEY","M_ITEM"}})






    // **************  Tabela Tributos ***********************/

    aAdd(aGridTrib,{"F2E_OK","OK","C",2,0,"@!"})
    aAdd(aGridTrib, yObterSX3("F2E_TRIB","F2E_TRIB","Codigo")) 
    aAdd(aGridTrib, yObterSX3("F2E_DESC","F2E_DESC","Descr")) 
    aAdd(aGridTrib, yObterSX3("F2E_IDTRIB","F2E_IDTRIB","Id Totvs")) 


    yAddEstrutura("X_GRID_TRIB",aGridTrib,{{"F2E_TRIB"},{"F2E_DESC"}})

Return 



/*/{Protheus.doc} User Function IniTab
Função de inicialização dos campos do Model
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
/*/
User Function IniTab(oModel,cCampo,xValue)

    If cCampo == "X_TABKEY"
        Return "001"
    EndIf

    
    If cCampo == "Z_TABKEY"
        Return oModel:GetModel():GetModel("M_FIELD_NCM"):GetValue("X_TABKEY")
    EndIf

    If cCampo == "Y_TABKEY"
        Return oModel:GetModel():GetModel("M_FIELD_NCM"):GetValue("X_TABKEY")
    EndIf

    If cCampo == "M_TABKEY"
        Return oModel:GetModel():GetModel("M_FIELD_NCM"):GetValue("X_TABKEY")
    EndIf

    If cCampo == "M_ITEM"
        Return strZero(oModel:Length()+1,4)
    EndIf

    If cCampo == "Y_ITEM"
        Return strZero(oModel:Length()+1,4)
    EndIf

Return


/*/{Protheus.doc} Static Function ModelX
Configuração do modelo MVC

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return object, Objeto do modelo MVC configurado
/*/
Static Function ModelX()

    Local oModel

    Local bPre      := { |A,B,C,D,E,F| actSetGrid(A,B,C,D,E,F) }

    Local oStrMField    := yObtStrMod("X_FIELD_NCM","Modelo NCM")
    Local oStrMGrid     := yObtStrMod("X_GRID_NCM","Modelo NCM")
    Local oStrGridAliq  := yObtStrMod("X_GRID_ALIQ","Modelo Aliquota")
    Local oStrGridMVA   := yObtStrMod("X_GRID_MVA","Modelo MVA")


    oStrMField:SetProperty('X_TABKEY',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))


    oStrMGrid:SetProperty('Z_TABKEY',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))


    oStrGridAliq:SetProperty('Y_TABKEY',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))

    oStrGridAliq:SetProperty('Y_ITEM',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))

    oStrGridMVA:SetProperty('M_TABKEY',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))

    oStrGridMVA:SetProperty('M_ITEM',MODEL_FIELD_INIT,;
        FWBuildFeature( STRUCT_FEATURE_INIPAD, "U_IniTab(a,b,c)" ))


    // ****** Configurando Model *****  //////

    oModel := MPFormModel():New('zFISC03M',/*bVldModelAll*/)

    oModel:AddFields('M_FIELD_NCM', , oStrMField, /*bVldMdField*/, , /*bLoad*/)

    oModel:AddGrid('M_GRID_NCM', 'M_FIELD_NCM', oStrMGrid, /*bLinePre*/, /*bLinePost*/, bPre, /*bPos*/, /*bLoad*/)
    //bLinePost  -> Valida a Linha
    //bPos       -> Valida o Modelo
    //bLoad      -> Ativação do Modelo


    oModel:AddGrid('M_GRID_ALIQ', 'M_FIELD_NCM', oStrGridAliq, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPos*/, /*bLoad*/)
    oModel:AddGrid('M_GRID_MVA', 'M_FIELD_NCM', oStrGridMVA, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPos*/, /*bLoad*/)



    //oModel:SetRelation('M_FIELD_NCM', { { 'X_TABKEY', 'Z_TABKEY' } })

    oModel:SetRelation('M_GRID_NCM', { { 'Z_TABKEY', 'X_TABKEY' } })
    oModel:SetRelation('M_GRID_ALIQ', { { 'Y_TABKEY', 'X_TABKEY' } })
    oModel:SetRelation('M_GRID_MVA', { { 'M_TABKEY', 'X_TABKEY' } })


    oModel:GetModel( 'M_GRID_NCM' ):SetUniqueLine( { "Z_TABKEY","Z_NCM","Z_CEST" } )
    oModel:GetModel( 'M_GRID_ALIQ' ):SetUniqueLine(;
         { "Y_TABKEY","Y_ITEM","Y_UFORI","Y_UFDEST","Y_ORIGEM" } )
    oModel:GetModel( 'M_GRID_MVA' ):SetUniqueLine(;
         { "M_TABKEY","M_ITEM","M_UFORI","M_UFDEST","M_ORIGEM" } )
    

    oModel:SetPrimaryKey({ 'X_TABKEY' })
    oModel:SetDescription("MODELO NCM")
    
    yObtEstru(aEstrura,"X_FIELD_NCM")[PREP_TAB_MODEL] := oModel:GetModel("M_FIELD_NCM")
    yObtEstru(aEstrura,"X_GRID_NCM")[PREP_TAB_MODEL]  := oModel:GetModel("M_GRID_NCM")
    yObtEstru(aEstrura,"X_GRID_ALIQ")[PREP_TAB_MODEL] := oModel:GetModel("M_GRID_ALIQ")
    yObtEstru(aEstrura,"X_GRID_MVA")[PREP_TAB_MODEL]  := oModel:GetModel("M_GRID_MVA")


    //oModel:GetModel("M_GRID_NCM"):SetLPost({  |oModel,nLine| actLineNCM(oModel,nLine) })
    //oModel:GetModel("M_GRID_ALIQ"):SetLPost({ |oModel,nLine| actLineAliq(oModel,nLine) })
    //oModel:GetModel("M_GRID_MVA"):SetLPost({  |oModel,nLine| actLineMVA(oModel,nLine) })



    oModel:SetActivate({ |oModel| LoadCof(oModel)  })

    

Return oModel


/*/{Protheus.doc} Static Function actSetGrid
Ação de validação/alteração na grid de NCM
Usado para engatilhar a Descrição do NCM

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
/*/
Static Function actSetGrid(oModNCM,nLine,cAction,cIDField,xValue,xCurrentValue)
    If cAction != "SETVALUE"
        Return .T.
    EndIf



    If cIDField == "Z_NCM"
    
        DBSelectArea("SYD")
        SYD->(DbSetOrder(1))
        SYD->(DbSeek(xFilial("SYD")+xValue))
        oModNCM:SetValue("Z_DESCR",SYD->YD_DESC_P)
        Return .T.
    
    EndIf


Return .T.


/*/{Protheus.doc} Static Function LoadCof
Carregamento configuração Inicial da Rotina

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@obs: Carrega os valores iniciais do Model
/*/
Static Function LoadCof(oModel)

    Local oModField := oModel:GetModel("M_FIELD_NCM")

    oModField:SetValue("X_PROATE","ZZZ")
    oModField:SetValue("X_GRBATE","ZZZ")
    oModField:SetValue("X_TRIATE","ZZZ")

    oModField:SetValue("X_TABELA","1")
    oModField:SetValue("X_FCEST","N")
    oModField:SetValue("X_FMVA","S")
    oModField:SetValue("X_IPI","S")
    oModField:SetValue("X_ABAS","T")
    oModField:SetValue("X_DATAVG",Date())



Return


/*/{Protheus.doc} Static Function ViewX
Configuração da view MVC

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return view MVC configurada
/*/
Static Function ViewX()
    Local oView

    Local oStrMaster    := yObtEstru(aEstrura,"X_FIELD_NCM")[PREP_TAB_ESTR_VIEW]
    Local oStrGrid      := yObtEstru(aEstrura,"X_GRID_NCM")[PREP_TAB_ESTR_VIEW]
    Local oStrGridAlq   := yObtEstru(aEstrura,"X_GRID_ALIQ")[PREP_TAB_ESTR_VIEW]
    Local oStrGridMVA   := yObtEstru(aEstrura,"X_GRID_MVA")[PREP_TAB_ESTR_VIEW]


    oView := FwFormView():New()

    oView:AddField('X_FIELD_NCM',   oStrMaster,     'M_FIELD_NCM')
    oView:AddGrid('X_GRID_NCM',     oStrGrid,       'M_GRID_NCM')
    oView:AddGrid('X_GRID_ALIQ',    oStrGridAlq,    'M_GRID_ALIQ')
    oView:AddGrid('X_GRID_MVA',     oStrGridMVA,    'M_GRID_MVA')


    oView:createVerticalBox( "ESQUERDA" , 80) 
    oView:createVerticalBox( "DIREITA"  , 20)

    oView:createHorizontalBox( "SUPERIOR"   , 25, "ESQUERDA" ) 
    oView:createHorizontalBox( "MEIO"       , 38, "ESQUERDA" ) 
    oView:createHorizontalBox( "INFERIOR"   , 37, "ESQUERDA" ) 

    oView:CreateFolder( 'FOLDER_NCM', 'MEIO' )

    oView:AddSheet('FOLDER_NCM', 'ABA_NCM',  "NCM" ) 
    oView:AddSheet('FOLDER_NCM', 'ABA_TRIB', "Tributos" ) 

    oView:CreateHorizontalBox( 'PAINEL_ABA_NCM', 100,,, 'FOLDER_NCM', 'ABA_NCM'        )
    oView:CreateHorizontalBox( 'PAINEL_ABA_TRIB', 100,,, 'FOLDER_NCM', 'ABA_TRIB'        )



    oView:CreateFolder( 'FOLDER_DADOS', 'INFERIOR' )

    oView:AddSheet('FOLDER_DADOS', 'ABA_ALIQ', "Aliquota" ) 
    oView:AddSheet('FOLDER_DADOS', 'ABA_MVA',  "Margem de Valor Agregado" ) 
    

    oView:CreateHorizontalBox( 'PAINEL_ABA_ALIQ', 100,,, 'FOLDER_DADOS', 'ABA_ALIQ'        )
    oView:CreateHorizontalBox( 'PAINEL_ABA_MVA' , 100,,, 'FOLDER_DADOS', 'ABA_MVA'        )



    oView:AddOtherObject("Painel_Botao", {|oPanel| PanelBotao(oPanel)})
    oView:AddOtherObject("Painel_Trib", {|oPanel| PanelTrib(oPanel)})

    oView:SetOwnerView('Painel_Botao', 'DIREITA')
    oView:SetOwnerView('Painel_Trib', 'PAINEL_ABA_TRIB')


    oView:SetOwnerView('X_FIELD_NCM',   'SUPERIOR')
    oView:SetOwnerView('X_GRID_NCM',    'PAINEL_ABA_NCM')
    oView:SetOwnerView('X_GRID_ALIQ',   'PAINEL_ABA_ALIQ')
    oView:SetOwnerView('X_GRID_MVA',    'PAINEL_ABA_MVA')


    oView:SetDescription("Grupo de Produtos em MVC")


return oView










/*/{Protheus.doc} Static Function PanelBotao
Criação do painel de botões da interface

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static function PanelBotao(oPanel)
    Local cFontNome   := 'Tahoma'
    //Local oFontPadrao := TFont():New(cFontNome, , -2)
    Local oBtnObj1
    Local oBtnObj2
    Local oBtnObj4
    Local oBtnObj5
    Local oBtnObj6
    Local oFontGrande := TFont():New(cFontNome, , -14, , .T.) 

    @ 10, 5 BUTTON oBtnObj1 PROMPT "Carregar NCM";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  Processa({|| PrepDados()}, 'Processando...') }

    @ 40, 5 BUTTON oBtnObj2 PROMPT "Aliquota Interestadual";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  LoadEst("I") }

    @ 70, 5 BUTTON oBtnObj3 PROMPT "Aliquota Destino";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  LoadEst("D") }

    @ 100, 5 BUTTON oBtnObj4 PROMPT "Gerar Regras NCM";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  Processa({|| IncNCM() })}




    @ 130, 5 BUTTON oBtnObj5 PROMPT "Limpar Abas";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  limpar() }

    @ 160, 5 BUTTON oBtnObj6 PROMPT "Finalizar";
        SIZE (oPanel:nWidth/2) -10 , 20 OF oPanel PIXEL ACTION {||  oDlgRegNcm:End() }


    oBtnObj1:SetFont(oFontGrande)
    oBtnObj2:SetFont(oFontGrande)
    oBtnObj3:SetFont(oFontGrande)
    oBtnObj4:SetFont(oFontGrande)
    oBtnObj5:SetFont(oFontGrande)
    oBtnObj6:SetFont(oFontGrande)
Return

/*/{Protheus.doc} Static Function Limpar
Limpeza das abas de alíquota e MVA

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function Limpar()
    Local oModGridAlq   := yObtEstru(aEstrura,"X_GRID_ALIQ")[PREP_TAB_MODEL]
    Local oModGridMva   := yObtEstru(aEstrura,"X_GRID_MVA")[PREP_TAB_MODEL]
    Local oView         := FWViewActive()


    oModGridAlq:ClearData(.T.,.T.)
    oModGridMva:ClearData(.T.,.T.)

    oView:Refresh()
Return 




/*/{Protheus.doc} Static Function PanelTrib
Criação do painel de tributos com browse de seleção

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function PanelTrib(oPanel)
    Local aSeek      := {}
    Local aCampSeek  := {}
    Local aEstrTrib  := yObtEstru(aEstrura,"X_GRID_TRIB")
    Local aColTela   := aEstrTrib[PREP_TAB_CAMPOS]
    Local cAliasTrib := aEstrTrib[PREP_TAB_OTEMP]:GetAlias()

    Local nIdx := 0

    Processa({|| LoadTrib()}, 'Processando...')

    nIdx := aScan(aColTela, { |aCol| aCol[1] == "F2E_OK" } )

    if nIdx > 0
        aDel(aColTela,nIdx)
        aSize(aColTela,len(aColTela)-1)
    EndIf

    aColTela := yBrowCols(aColTela,cAliasTrib)  
    aCampSeek := yObterSX3("F2E_TRIB")

    aAdd(aSeek,{ aCampSeek[2],{{"", aCampSeek[3],aCampSeek[4],aCampSeek[5],aCampSeek[2], aCampSeek[6]}}}  )



    oMarkTrib := FWMarkBrowse():New()

        aEstrTrib[PREP_TAB_MODEL] := oMarkTrib

        oMarkTrib:SetDescription("Lista de Tributo") 
        oMarkTrib:SetAlias(cAliasTrib)

        oMarkTrib:oBrowse:SetDBFFilter(.T.)
        oMarkTrib:oBrowse:SetUseFilter(.F.) 
        //oMarkBrowse:oBrowse:SetFixedBrowse(.T.)
        oMarkTrib:oBrowse:SetSeek(,aSeek) //Habilita a utilização da pesquisa de registros no Browse
        oMarkTrib:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
       	oMarkTrib:DisableReport()
	    oMarkTrib:DisableConfig()

        // oMarkBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
        //oMarkBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
        oMarkTrib:SetTemporary(.T.) //Indica que o Browse utiliza tabela temporária
        oMarkTrib:SetFieldMark("F2E_OK")
        oMarkTrib:SetOwner(oPanel)
        oMarkTrib:SetColumns(aColTela)
        oMarkTrib:Activate()

Return




/*/{Protheus.doc} Static Function EstrView
Configuração das estruturas das views

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function EstrView()
    Local oStrFieldCFG  := yObtStrView("X_FIELD_NCM")
    Local oStrGridNCM   := yObtStrView("X_GRID_NCM")
    Local oStrGridAliq  := yObtStrView("X_GRID_ALIQ")
    Local oStrGridMVA   := yObtStrView("X_GRID_MVA")


    /************* Estrutura da Configuração ***************/


    oStrFieldCFG:AddFolder("F01", "Principal")
    oStrFieldCFG:AddFolder("F02", "Filtro")


    // Folder 01 - Principal
    ySetStrProp(oStrFieldCFG,"Folder","F01",;
        {"X_TABELA","X_FCEST","X_FMVA","X_IPI","X_ABAS","X_DATAVG"})
    

    // Folder 02 - Filtro
    ySetStrProp(oStrFieldCFG,"Folder","F02",;
        {"X_PRODE","X_PROATE","X_GRBDE","X_GRBATE","X_TRIDE","X_TRIATE"})


    // Combobox
    ySetStrProp(oStrFieldCFG,"Combo",{"N=Não","S=Sim"},;
        {"X_FCEST","X_FMVA","X_IPI"})

    ySetStrProp(oStrFieldCFG,"Combo",{"1=SB1","Z=SBZ"},;
        {"X_TABELA"})

    ySetStrProp(oStrFieldCFG,"Combo",{"T=Todas","A=Aba Aliquota","M=Aba MVA","N=Nenhuma"},;
        {"X_ABAS"})

    // Busca Consulta Padrão
    ySetStrProp(oStrFieldCFG,"F3", GetSX3Cache("F24_CDPROD","X3_F3"),  {"X_PRODE","X_PROATE"})
    ySetStrProp(oStrFieldCFG,"F3", GetSX3Cache("B1_GRUPO"  ,"X3_F3"),  {"X_GRBDE","X_GRBATE"})
    ySetStrProp(oStrFieldCFG,"F3", GetSX3Cache("B1_GRTRIB" ,"X3_F3"),  {"X_TRIDE","X_TRIATE"})


    ySetStrProp(oStrFieldCFG,"Remove",,;
        {"X_TABKEY"})



    /************* Estrutura da Grid de Aliq ***************/



    ySetStrProp(oStrGridAliq,"Editar",.F.,;
        {"Y_TABKEY","Y_ITEM"})

    ySetStrProp(oStrGridAliq,"Combo",{"0=Padrao","1=Aux 01","2=Aux 02"},;
        {"Y_TBNCM"})


    ySetStrProp(oStrGridAliq,"F3", GetSX3Cache("CIU_UFORI","X3_F3"),;
        {"Y_UFORI","Y_UFDEST"})

    ySetStrProp(oStrGridAliq,"F3", GetSX3Cache("CIU_ORIGEM","X3_F3"),;
        {"Y_ORIGEM"})


    ySetStrProp(oStrGridAliq,"Remove",,;
        {"Y_TABKEY"})


    /************* Estrutura da Grid de MVA ***************/

    ySetStrProp(oStrGridMVA,"Editar",.F.,;
        {"M_TABKEY","M_ITEM"})

    ySetStrProp(oStrGridMVA,"Combo",{"0=Padrao","1=Aux 01","2=Aux 02"},;
        {"M_TBNCM"})

    ySetStrProp(oStrGridMVA,"F3", GetSX3Cache("CIU_UFORI","X3_F3"),;
        {"M_UFORI","M_UFDEST"})

    ySetStrProp(oStrGridMVA,"F3", GetSX3Cache("CIU_ORIGEM","X3_F3"),;
        {"M_ORIGEM"})

    ySetStrProp(oStrGridMVA,"Remove",,;
        {"M_TABKEY"})


    /************* Estrutura da Grid de NCM ***************/
    ySetStrProp(oStrGridNCM,"F3", GetSX3Cache("CIS_CODNCM","X3_F3"),;
        {"Z_NCM"})

    ySetStrProp(oStrGridNCM,"Editar",.F.,;
        {"Z_TABKEY"})

    ySetStrProp(oStrGridNCM,"Remove",,;
        {"Z_TABKEY"})
Return






/*/{Protheus.doc} Static Function PrepDados
Carrega as NCMs Cadastradas nos Produtos

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function  PrepDados()

    Local cAlias        := FWGetArea()

    Local oModParm      := yObtEstru(aEstrura,"X_FIELD_NCM")[PREP_TAB_MODEL]
    Local oModNCM       := yObtEstru(aEstrura,"X_GRID_NCM")[PREP_TAB_MODEL]

    Local oView         := FWViewActive()

        
    Local aNcm          := {}
    Local bBuscaRep

    Local lBuscaCest    := oModParm:GetValue("X_FCEST") == "S"
    Local lBuscaMVA     := oModParm:GetValue("X_FMVA") == "S"
    Local lBuscaIPI     := oModParm:GetValue("X_IPI") == "S"


    Local cTabProd      := oModParm:GetValue("X_TABELA")

    Local cProdDe       := oModParm:GetValue("X_PRODE")
    Local cProdAte      := oModParm:GetValue("X_PROATE")
    Local cGrupoDe      := oModParm:GetValue("X_GRBDE")
    Local cGrupoAte     := oModParm:GetValue("X_GRBATE")
    Local cTriboDe      := oModParm:GetValue("X_TRIDE")
    Local ctribAte      := oModParm:GetValue("X_TRIATE")

    Local nMVA          := 0
    Local nIPI          := 0
    Local cCest         := "   "
    Local nTotal        := 0
    Local nIx


    Local bPassGrpTrib  := { || SB1->B1_GRTRIB >= cTriboDe .AND. SB1->B1_GRTRIB <= ctribAte}
  


  

    oModNCM:ClearData(.T.,.T.)


    If cTabProd == "Z"  //Tabela SBZ
        bPassGrpTrib := { || SBZ->BZ_GRTRIB >= cTriboDe .AND. SBZ->BZ_GRTRIB <= ctribAte}
    EndIf

    DbSelectArea("SBZ")
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    //SB1->(DbSeek(xFilial("SB1")+cProdDe))


    nTotal := Contar("SB1", "SB1->B1_COD >= '" + cProdDe + "' .And. SB1->B1_COD <= '" + cProdAte + "'")
    ProcRegua(nTotal)
    
    SB1->(DbGoTop())
    //SB1->(DbSeek(xFilial("SB1")+cProdDe))



    While  xFilial("SB1")+SB1->B1_COD >= xFilial("SB1")+cProdDe .AND.;
        xFilial("SB1")+SB1->B1_COD <= xFilial("SB1")+cProdAte
        
        IncProc('Analisando registro ...')
    
        If SB1->(EoF())
            Exit 
        EndIf


        IF !(SB1->B1_GRUPO >= cGrupoDe .AND. SB1->B1_GRUPO <= cGrupoAte)
            SB1->(DbSkip())
            Loop
        EndIf

        IF SB1->B1_ATIVO == "N" .OR. SB1->B1_MSBLQL == "1"
            SB1->(DbSkip())
            Loop
        EndIf

        If AllTrim(SB1->B1_POSIPI) == ""
            SB1->(DbSkip())
            Loop
        EndIf


        nMVA := SB1->B1_PICMRET
        nIPI := SB1->B1_IPI	
        
        If cTabProd == "Z"  //Tabela SBZ
            
            SBZ->(DbSetOrder(1))
            if (SBZ->(DbSeek(xFilial("SBZ")+SB1->B1_COD)))
                nMVA := SBZ->BZ_PICMRET
                nIPI := SBZ->BZ_IPI
            EndIf
            
        EndIf

        // Grupo de tribudo considerando SB1 OU SBZ
        If !Eval(bPassGrpTrib)
            SB1->(DbSkip())
            Loop
        EndIf

        // Necessario agrupar por CEST
        If lBuscaCest
            cCest := SB1->B1_CEST
            bBuscaRep := { |x| x[1] + x[2] == SB1->B1_POSIPI+SB1->B1_CEST }

            if alltrim(cCest) != ""
                
                nPosCEST := aScan(aNcm, { |x| x[1] + x[2] == SB1->B1_POSIPI+space(LEN(cCest)) })
                
                if nPosCEST > 0
                    aDel(aNcm, nPosCEST)
                    aSize(aNcm, len(aNcm)-1)    
                EndIf
                
            EndIf
            
        Else
            cCest := "   "
            bBuscaRep := { |x| x[1] == SB1->B1_POSIPI}
        EndIf



        If aScan(aNcm, bBuscaRep ) == 0

            aAdd(aNcm, {SB1->B1_POSIPI, cCest,iif(lBuscaMVA,nMVA,0),iif(lBuscaIPI,nIPI,0)})

        EndIf
        
        SB1->(DbSkip())

    EndDo

    for nIx := 1 to len(aNcm)

        If !Empty(AllTrim(oModNCM:GetValue("Z_NCM")))
            oModNCM:AddLine()
        EndIf

        oModNCM:SetValue("Z_TABKEY","001")
        oModNCM:SetValue("Z_NCM",aNcm[nIx,1])
        oModNCM:SetValue("Z_CEST",aNcm[nIx,2])
        oModNCM:SetValue("Z_AUX01",iif(lBuscaMVA,aNcm[nIx,3],0))
        oModNCM:SetValue("Z_AUX02",iif(lBuscaIPI,aNcm[nIx,4],0))

    Next


    oModNCM:GoLine(1)
    oView:Refresh()

    FwRestArea(cAlias)
Return .T.



/*/{Protheus.doc} Static Function LoadEst
Facilita o carregamento da aba aliquota

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/

Static Function LoadEst(xValue)

    Local cEstado    := GetNewPar("MV_ESTADO")
    Local aNorteAux  := StrTokArr2(GetNewPar("MV_NORTE"),"/",.F.)
    Local aNorte     := {}
    Local lOrigemSul := aScan(aNorte,{|x| x == cEstado }) == 0
    Local cUFOrg     := cEstado
    Local cUFDest    := ""

    Local nAliq      := 0
    Local nIx

    Local oView      := FWViewActive()
    Local oModGrid   := yObtEstru(aEstrura,"X_GRID_ALIQ")[PREP_TAB_MODEL]

    Local aEstados := {;
        {"PR",17.0},{"SC",17.0},{"RS",18.0},;                                   // Sul
        {"SP",18.0},{"RJ",22.0},{"MG",18.0},{"ES",17.0},;                       // Sudeste
        {"DF",20.0},{"GO",19.0},{"MS",17.0},{"MT",17.0},;                       // Centro-Oeste
        {"AL",19.0},{"BA",18.0},{"CE",18.0},{"MA",23.0},{"PB",18.0},;           // Nordeste
        {"PE",18.0},{"PI",22.5},{"RN",20.0},{"SE",18.0},;                       // Nordeste
        {"AC",19.0},{"AM",20.0},{"AP",18.0},{"PA",17.0},{"RO",17.0},;           // Norte
        {"RR",20.0},{"TO",20.0}}                                                // Norte


    aEval(aNorteAux, {|x| aAdd(aNorte,alltrim(x)) })

    oModGrid:ClearData(.T.,.T.) 

    For nIx:=1 To Len(aEstados)
    
        cUFOrg      := cEstado
        cUFDest     := aEstados[nIx,1]
        lDestNorte  := aScan(aNorte,{|x|  x == aEstados[nIx,1]}) > 0


        If ( cUFDest == cEstado .AND.  xValue != "D")
            cUFOrg := "**"
        EndIf


        If xValue == "D"
            nAliq := aEstados[nIx,2]
            cUFOrg := "**"
        EndIf

        If xValue == "I"
            If lOrigemSul .AND. lDestNorte
                nAliq := 7
            Else
                nAliq := 12
            EndIf
        EndIf

        If oModGrid:Length() > 0 .AND. !Empty(AllTrim(oModGrid:GetValue("Y_UFORI")))
            oModGrid:AddLine()
        EndIf


        oModGrid:SetValue("Y_TABKEY","001")
        oModGrid:SetValue("Y_ITEM",strZero(nIx,4))
        oModGrid:SetValue("Y_UFORI",cUFOrg)
        oModGrid:SetValue("Y_UFDEST",cUFDest)
        oModGrid:SetValue("Y_ORIGEM","*")
        oModGrid:SetValue("Y_ALIQTR",nAliq)

        
    Next

    oModGrid:GoLine(1)
    oView:Refresh()

return 




/*/{Protheus.doc} Static Function LoadTrib
Carrega os Tributos para tabela Temporária

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function LoadTrib()

    Local cQryDados := ''
    Local nTotal    := 0
    Local nAtual    := 0

    Local cAliasTrib := yObtEstru(aEstrura,"X_GRID_TRIB")[PREP_TAB_OTEMP]:GetAlias()    

	cQryDados := "SELECT '  ' as F2E_OK, F2E_TRIB, F2E_DESC, F2E_IDTRIB "    + CRLF
	cQryDados += "FROM " + RetSqlName("F2E") + " F2E "          + CRLF
	cQryDados += "WHERE F2E_FILIAL = '" + xFilial("F2E") + "' " + CRLF
	cQryDados += "  AND F2E.D_E_L_E_T_ = ' ' "                  + CRLF
	cQryDados += "ORDER BY F2E_TRIB"                            + CRLF

  
    PLSQuery(cQryDados, 'QRYDADTMP')
  

    DbSelectArea('QRYDADTMP')
    Count to nTotal
    ProcRegua(nTotal)
    QRYDADTMP->(DbGoTop())
  

    While ! QRYDADTMP->(EoF())
        nAtual++

        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
  
        RecLock(cAliasTrib, .T.)
            (cAliasTrib)->F2E_OK     := Space(2)
            (cAliasTrib)->F2E_TRIB   := QRYDADTMP->F2E_TRIB
            (cAliasTrib)->F2E_DESC   := QRYDADTMP->F2E_DESC
            (cAliasTrib)->F2E_IDTRIB := QRYDADTMP->F2E_IDTRIB
        (cAliasTrib)->(MsUnlock())
  
        QRYDADTMP->(DbSkip())
    EndDo

    QRYDADTMP->(DbCloseArea())
    (cAliasTrib)->(DbGoTop())
Return
  

/*/{Protheus.doc} Static Function yObtEstru
Lib -> Busca no array de estruturas a estrutura desejada
array de estruturas, para evitar um monte variavel privada 

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function yObtEstru(aEstrura,nome)
    Local nPosX   := aScan(aEstrura,{ |x| x[PREP_TAB_NOME] == nome})
Return aEstrura[nPosX]


/*/{Protheus.doc} Static Function yObtStrMod
Lib -> Monta a estrutura do model baseado na estrutura criada no PrepTabela

array de estruturas, para evitar um monte variavel privada
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function yObtStrMod(cNome,cDescricao)

    Local aItem   := yObtEstru(aEstrura,cNome)
    Local oStrModel := FWFormModelStruct():New()
    Local oTmpTabela := aItem[PREP_TAB_OTEMP]
    Local aCampos := aItem[PREP_TAB_CAMPOS]
    Local nIx

    
    oStrModel:AddTable(oTmpTabela:GetAlias(), yObtCampos(aCampos) ,;
        cDescricao, {|| oTmpTabela:GetRealName()})
 

    For nIx:=1 to len(aCampos)
        yBasModStr(oStrModel, aCampos[nIx], oTmpTabela:GetAlias() )
    Next


Return oStrModel




/*/{Protheus.doc} Static Function yBasModStr
Lib -> Monta o Campo do model 
evita um monte de codigo repetido e feio
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function yBasModStr(oStrMod,aField,cAlias)

    Local bInit

    oStrMod:AddField(;
        aField[2]   /*cTitulo*/,;
        aField[2]   /*cTitulo*/,;
        aField[1]   /*cNome*/,;
        aField[3]   /*cTipo*/,;
        aField[4]   /*nTamanho*/,;
        aField[5]   /*nDecimal*/,;
        Nil,;       // [07] Função de validação do campo
        Nil,;       // [08] Função de validação When do campo
        {},;        // [09] Lista de valores permitido do campo (Combo)
        .F.,;       // [10] Indica se o campo tem preenchimento obrigatório
        Nil,;       // [11] incializador
        .F.,;       // [12] Indica se trata de um campo chave
        .F.,;       // [13] Indica se o campo não pode receber valor em uma operação de update
        .F.)        // [14] Indica se o campo é virtual


    bInit := FWBuildFeature(  STRUCT_FEATURE_INIPAD,cAlias+"->"+aField[1])
    oStrMod:SetProperty(aField[1],MODEL_FIELD_INIT,bInit)


return 



/*/{Protheus.doc} Static Function yObtStrView
Lib -> Monta a estrutura do view baseado na estrutura criada no PrepTabela

array de estruturas, para evitar um monte variavel privada
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function yObtStrView(cNome)
    Local oStrView  := FWFormViewStruct():New()
    Local aItem     := yObtEstru(aEstrura,cNome)
    Local aCampos   := aItem[PREP_TAB_CAMPOS]
    Local nIx

    
    aItem[PREP_TAB_ESTR_VIEW]  := oStrView

    For nIx:=1 to len(aCampos)
        yBasViewStr(oStrView,strZero(nIx,2),aCampos[nIx])
    Next

Return oStrView

/*/{Protheus.doc} Static Function yBasViewStr
Lib -> Monta o Campo do view 
evita um monte de codigo repetido e feio
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function yBasViewStr(oStrFild,cOrdem,aField)


    oStrFild:AddField(;
        aField[1]               /*cNome*/,;
        cOrdem,                 /*Ordem*/;
        aField[2]               /*cTitulo*/,;
        aField[2]               /*cTitulo*/,;
        Nil                     /*Help */,;
        aField[3],  aField[6]   /*cTipo         -- cPicture*/,;
        Nil,        Nil,        /*bPictVar      -- cLookUp F3*/ ;
        .T.,        Nil,        /*lAlterado     -- cFolder*/;
        Nil,        Nil,        /*cGroup        -- aComboValues*/; 
        Nil,        Nil,        /*nMaxLenCombo  -- cIniBrow*/;
        Nil,        Nil,        /*lVirtual      -- cPictVar*/;
        Nil,        Nil)        /*lInsertLine   -- nWidth*/;
    
Return




/*/{Protheus.doc} Static Function yAdptaTab
Lib -> Altera o array de campos, ajustando para tabela temporária
removendo o campo Picture e Descrição
retornando apenas a estrutura de tabela
@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Array de campos
/*/
Static Function yAdptaTab(aCampView)

    Local nIx
    Local aCampo
    Local aCampos := {}

    For nIx := 1 to len(aCampView)
        aCampo := aCampView[nIx]
        aAdd(aCampos, {aCampo[1], aCampo[3],aCampo[4],aCampo[5] })
    Next

return aCampos



/*/{Protheus.doc} Static Function yObtCampos
Lib -> Retona apenas o nome dos campos da estrutura

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Array de campos
/*/
Static Function yObtCampos(aCampView,aCamposManual)

    Local nIx
    Local aCampos := {}
    Default aCamposManual := {}

    For nIx := 1 to len(aCamposManual)
        aAdd(aCampos, aCamposManual[nIx])
    Next

    For nIx := 1 to len(aCampView)
        aAdd(aCampos, aCampView[nIx,1])
    Next

return aCampos




/*/{Protheus.doc} Static Function yObterSX3
Lib -> Retona a estrutura do campo SX3

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Array de campos
/*/
Static Function yObterSX3(cCampo,cNovoNome, cNovaDesc)

    Local aCampView   := {}
    Default cNovoNome := cCampo
    Default cNovaDesc := alltrim(GetSX3Cache(cCampo,"X3_titulo"))


    aSX3 := FWSX3Util():GetFieldStruct(cCampo)
    aCampView := { cNovoNome, cNovaDesc , aSX3[2],  aSX3[3], aSX3[4], allTrim(aSX3[5])}

return aCampView 




/*/{Protheus.doc} Static Function ySetStrProp
Lib -> Define as propriedades dos campos do model

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static Function ySetStrProp(oStr,cTipo,xValor,aCampos)
    Local nIx := 0
    Default xValor := ""

    For nIx:=1 To Len(aCampos)

        if cTipo == "Folder"
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_FOLDER_NUMBER,xValor)
        Endif

        if cTipo == "Grupo"
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_GROUP_NUMBER,xValor)
        Endif

        if cTipo == "Combo"
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_COMBOBOX,xValor)
        Endif

        if cTipo == "F3"
            SetFunName("FWEXECVIEW")
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_LOOKUP,xValor)
        Endif

        if cTipo == "Remove"
            oStr:RemoveField(aCampos[nIx])
        Endif

        if cTipo == "Tamanho"
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_WIDTH,xValor)
        Endif

        IF cTipo == "Editar"
            oStr:SetProperty(aCampos[nIx],MVC_VIEW_CANCHANGE,xValor)
        Endif

    Next
Return






/*/{Protheus.doc} Static Function yBrowCols
Lib -> Define as colunas do browser
baseado na estrutura preparada

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Array de colunas
/*/
Static Function yBrowCols(aColTela,cAlias)
    Local nAtual       := 0 
    Local aColunas := {}
    Local oColumn

    For nAtual := 1 To Len(aColTela)

        oColumn := FWBrwColumn():New()
        oColumn:SetData(&('{|| ' + cAlias + '->' + aColTela[nAtual][1] +'}'))
        oColumn:SetTitle(aColTela[nAtual][2])
        oColumn:SetType(aColTela[nAtual][3])
        oColumn:SetSize(aColTela[nAtual][4])
        oColumn:SetDecimal(aColTela[nAtual][5])
        oColumn:SetPicture(aColTela[nAtual][6])
        oColumn:SetID(aColTela[nAtual][1])

  
        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas



/*/{Protheus.doc} Static function yBrowSetProp
Lib -> Define as propriedades das colunas do browser

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static function yBrowSetProp(aColumns,cTipo,xValor,aCampos)

    Local nIx
    Local cEdit
    Local oColumn

    For nIx:=1 To Len(aCampos)

       oColumn := aColumns[aScan(aColumns,{ |x| x:cID == aCampos[nIx] })]

        If cTipo == "Editar"
            oColumn:SetEdit(.T.)
            cEdit   := xValor + "->" + oColumn:cID
            oColumn:SetReadVar( cEdit )
        EndIf

        If cTipo == "F3"
           oColumn:xF3 := xValor
        EndIf

        If cTipo == "Valid"
           oColumn:SetValid(xValor)
        EndIf

        if cTipo == "Combo"
            oColumn:SetOptions(xValor)
        Endif

    Next    


Return



  



/*/{Protheus.doc} Static Function yAddEstrutura
Lib -> Cria tabela temporária baseada na estrutura preparada
adicona a tabela ao array de estruturas

@type  Function
@author Andre Amador
@since 09/08/2025
@version 1.0
@return Nil
/*/
Static function yAddEstrutura(cNome,aCampo,aIndex)

    Local oTmpTab   := FWTemporaryTable():New(GetNextAlias())
    Local aItem     := Array(6)
    Local aFields   := yAdptaTab(aCampo)
    Local nIx

    oTmpTab:SetFields( aFields )

    For nIx := 1 To len(aIndex)
        oTmpTab:AddIndex(strZero(nIx,2), aIndex[nIx] )
    Next

    oTmpTab:Create()

    aItem[PREP_TAB_NOME]   := cNome
    aItem[PREP_TAB_CAMPOS] := aCampo
    aItem[PREP_TAB_OTEMP]  := oTmpTab

    aAdd(aEstrura,aItem)
Return






Static Function IncNCM()

    Local nIx
    Local nIxSub

    Local lRet              := .T.
    Local lModificado       := .F.
    Local lAbaIncr          := .F.
    Local lValid            := .F.
    Local cNcm              := ""
    Local nTotal            := 0
    Local oModNcm           := yObtEstru(aEstrura,"X_GRID_NCM")[PREP_TAB_MODEL]
    Local oMarkTrib         := yObtEstru(aEstrura,"X_GRID_TRIB")[PREP_TAB_MODEL]
    Local cMarcTrib         := oMarkTrib:Mark()
    Local cAliasTrib        := oMarkTrib:Alias()
    Local cMessage          := ""

    Local aAreaTrib   := (cAliasTrib)->(FwGetArea())
    Local nPosMark    := oMarkTrib:At()

    (cAliasTrib)->(DbGoTop())

    While !(cAliasTrib)->(Eof())
   
        If (cAliasTrib)->F2E_OK  == cMarcTrib
            cMessage += " / "+ (cAliasTrib)->F2E_TRIB 
        EndIf

        (cAliasTrib)->(DbSkip())
    EndDo


    If !FWAlertNoYes("Tributos Selecionados: "+cMessage,"Continuar ?")
        oModNcm:GoLine(1)
        FwRestArea(aAreaTrib)
        oMarkTrib:GoTo(nPosMark,.t.)    
        Return
    EndIf


    nTotal := oModNcm:Length()
    ProcRegua(nTotal)


    DBSelectArea("CIS")
    CIS->(DbSetOrder(1))


    Begin Transaction
        
        For nIx:=1 to oModNcm:Length()

            IncProc('Gerando Regras NCM ...')


            oModNcm:GoLine(nIx)

            oMdRegNCM := FWLoadModel('FISA160B')
            oMdCabNCM := oMdRegNCM:getModel("FISA160B")


            if oModNcm:IsDeleted()
                Loop
            Endif

            if cNcm == oModNcm:GetValue("Z_NCM")
                lAbaIncr := .T.
            Endif
        
            cNcm  := oModNcm:GetValue("Z_NCM")

            //Exite NCM 
            IF CIS->(DBSeek(xFilial("CIS")+cNcm))
                oMdRegNCM:SetOperation( MODEL_OPERATION_UPDATE )
                oMdRegNCM:Activate()
                
                incTributo(oMdRegNCM,lAbaIncr)

            Else
                oMdRegNCM:SetOperation( MODEL_OPERATION_INSERT )
                oMdRegNCM:Activate()

                oMdCabNCM:SetValue("CIS_CODNCM",oModNcm:GetValue("Z_NCM"))            

                incTributo(oMdRegNCM,lAbaIncr)
            EndIf   //aAllSubmodels

            For nIxSub := 1 To len(oMdRegNCM:aAllSubmodels)
                If oMdRegNCM:aAllSubmodels[nIxSub]:IsModified()
                    lModificado := .T.
                EndIf
            Next


            lValid := oMdRegNCM:VldData() 
            
            If lValid .AND. lModificado
                lRet := oMdRegNCM:CommitData()
            EndIf

            If !lValid .OR. !lRet
                DisarmTransaction()
                AutoGrLog(oMdRegNCM:GetErrorMsgText())
                MostraErro()
                Exit
            EndIf

            lValid := .F.
            lModificado := .F.  

            oMdRegNCM:DeActivate()
            oMdRegNCM:Destroy()

            lAbaIncr := .F.

        Next 
    
    End Transaction

    oModNcm:GoLine(1)

    FwRestArea(aAreaTrib)
    oMarkTrib:GoTo(nPosMark,.t.)

Return





Static Function incTributo(oMdRegNCM,lAbaIncr)

    Local oMdNcmTrib

    Local oMarkTrib  := yObtEstru(aEstrura,"X_GRID_TRIB")[PREP_TAB_MODEL]

    Local cMarcTrib   := oMarkTrib:Mark()
    Local cAliasTrib  := oMarkTrib:Alias()


    DBSelectArea(cAliasTrib)
    DBSetOrder(1)
    (cAliasTrib)->(DbGoTop())

    //Roda Tributos do Mark
    While !(cAliasTrib)->(Eof())
   
        If (cAliasTrib)->F2E_OK  != cMarcTrib
            (cAliasTrib)->(DbSkip())
            Loop
        EndIf

        oMdNcmTrib := oMdRegNCM:GetModel("FISA160BTRIB")

        //Verifica se já existe Tributo Cadastrado
        If oMdNcmTrib:SeekLine({{"CIT_TRIB",(cAliasTrib)->F2E_TRIB}})
            incAbas(oMdRegNCM,lAbaIncr)
            (cAliasTrib)->(DbSkip())
            Loop
        Endif

        If oMdNcmTrib:Length() > 0 .AND. !Empty(AllTrim(oMdNcmTrib:GetValue("CIT_TRIB")))
            oMdNcmTrib:AddLine()
        EndIf

        oMdNcmTrib:SetValue("CIT_TRIB",(cAliasTrib)->F2E_TRIB)
        incAbas(oMdRegNCM,lAbaIncr)
        (cAliasTrib)->(DbSkip())
    
    EndDo


Return





Static Function incAbas(oMdRegNCM,lAbaIncr)

    Local nIx        := 0
    Local oMdRegAlq  := oMdRegNCM:GetModel("FISA160BCFGALIQ")
    Local oMdRegMva  := oMdRegNCM:GetModel("FISA160BCFGMVA")

    Local oModNcmAlq := yObtEstru(aEstrura,"X_GRID_ALIQ")[PREP_TAB_MODEL]
    Local oModNcmMva := yObtEstru(aEstrura,"X_GRID_MVA")[PREP_TAB_MODEL]
    Local oModNcm    := yObtEstru(aEstrura,"X_GRID_NCM")[PREP_TAB_MODEL]
    Local oModParm   := yObtEstru(aEstrura,"X_FIELD_NCM")[PREP_TAB_MODEL]


    Local cCest     := oModNcm:GetValue("Z_CEST")
    Local cOperacao := oModParm:GetValue("X_ABAS")
    Local cDataVG   := oModParm:GetValue("X_DATAVG")
    Local nItem     := 0


    oMdRegAlq:GoLine(oMdRegAlq:Length())

    If cOperacao == "T" .OR. cOperacao == "A"

        if !lAbaIncr
            DelLineModel(oMdRegAlq,"CIU_UFORI")
        Endif


        For nIx := 1 To oModNcmAlq:Length()
            oModNcmAlq:GoLine(nIx)
                    
            If oModNcmAlq:IsDeleted()
                Loop
            EndIf

            If !Empty(AllTrim(oMdRegAlq:GetValue("CIU_UFORI")))
                oMdRegAlq:AddLine()
            EndIf

            nItem := iif(lAbaIncr, oModNcmAlq:Length() + 1, oModNcmAlq:Length())

            oMdRegAlq:SetValue("CIU_ITEM"       ,strZero(nItem,4))
            oMdRegAlq:SetValue("CIU_UFORI"      ,oModNcmAlq:GetValue("Y_UFORI"))
            oMdRegAlq:SetValue("CIU_UFDEST"     ,oModNcmAlq:GetValue("Y_UFDEST"))
            oMdRegAlq:SetValue("CIU_VIGINI"     ,cDataVG)
            oMdRegAlq:SetValue("CIU_ORIGEM"     ,oModNcmAlq:GetValue("Y_ORIGEM"))
            oMdRegAlq:SetValue("CIU_CEST"       ,cCest)
            oMdRegAlq:SetValue("CIU_ALIQTR"     ,oModNcmAlq:GetValue("Y_ALIQTR"))

            If oModNcmAlq:GetValue("Y_TBNCM") == "1"
                oMdRegAlq:SetValue("CIU_ALIQTR", oModNcm:GetValue("Z_AUX01"))
            EndIf

            If oModNcmAlq:GetValue("Y_TBNCM") == "2"
                oMdRegAlq:SetValue("CIU_ALIQTR", oModNcm:GetValue("Z_AUX02"))
            EndIf

        Next

    EndIf



    If cOperacao == "T" .OR. cOperacao == "M"


        if !lAbaIncr
            DelLineModel(oMdRegMva,"CIU_UFORI")
        Endif

        For nIx := 1 To oModNcmMva:Length()
            oModNcmMva:GoLine(nIx)
                    
            If oModNcmMva:IsDeleted()
                Loop
            EndIf

            If !Empty(AllTrim(oMdRegMva:GetValue("CIU_UFORI")))
                oMdRegMva:AddLine()
            EndIf

            nItem := iif(lAbaIncr, oModNcmMva:Length() + 1, oModNcmMva:Length())

            oMdRegMva:SetValue("CIU_ITEM"       ,strZero(nItem,4))
            oMdRegMva:SetValue("CIU_UFORI"      ,oModNcmMva:GetValue("M_UFORI"))
            oMdRegMva:SetValue("CIU_UFDEST"     ,oModNcmMva:GetValue("M_UFDEST"))
            oMdRegMva:SetValue("CIU_VIGINI"     ,cDataVG)
            oMdRegMva:SetValue("CIU_ORIGEM"     ,oModNcmMva:GetValue("M_ORIGEM"))
            oMdRegMva:SetValue("CIU_CEST"       ,cCest)
            oMdRegMva:SetValue("CIU_MARGEM"     ,oModNcmMva:GetValue("M_MVA"))
            oMdRegMva:SetValue("CIU_MVAAUX"     ,oModNcmMva:GetValue("M_MVAAUX"))

            
            If oModNcmMva:GetValue("M_TBNCM") == "1"
                oMdRegMva:SetValue("CIU_MARGEM", oModNcm:GetValue("Z_AUX01"))
            EndIf

            If oModNcmMva:GetValue("M_TBNCM") == "2"
                oMdRegMva:SetValue("CIU_MARGEM", oModNcm:GetValue("Z_AUX02"))
            EndIf

        Next
    EndIf


Return


Static Function DelLineModel(oModel,cCampo)
    Local nIx := 0
    
    For nIx := 1 To oModel:Length()
        oModel:GoLine(nIx)

        If !Empty(AllTrim(oModel:GetValue(cCampo)))
            oModel:DeleteLine()
        EndIf
    Next

Return
