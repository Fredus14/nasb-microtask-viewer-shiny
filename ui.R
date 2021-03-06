library(shiny)
library(ggvis)

#' Input separator choice
#'
seperator_input <- radioButtons(
    'sep', 'Separator',
    c(Comma=',', Semicolon=';', Tab='\t'),
)

#' Dataset download 
#'
upload_tab <- tabPanel(
    'Upload dataset',
    fluidRow(
        column(12, p('')),
        column(6, wellPanel(
            h3('Expression data'),
            uiOutput('datain_container'),
            seperator_input        
        )),
        column(6, wellPanel(
            h3('Control samples', id='control_samples'),
            uiOutput('sampleclass_container')
        )),
        column(12, 
            h3('Input preview', id='datain_preview'),
            dataTableOutput('contents')
        )
    )
)

#' Characteristic Direction Analysis ouput tab
#'
chdir_tab <- tabPanel(
    'Characteristic Direction Analysis',
    fluidRow(
        column(12, p('')),
             column(12, 
        column(4, wellPanel(
            tags$dl(
                tags$dt('#genes:'),
                tags$dd(textOutput('ngenes')),
                tags$dt('#probes:'),
                tags$dd(textOutput('nprobes')),
                tags$dt('Control samples:'),
                tags$dd(textOutput('control_samples')),
                tags$dt('Treatment samples:'),
                tags$dd(textOutput('treatment_samples'))
            )
        )),
   
        column(4, wellPanel(
            numericInput('chdir_gamma', 'Gamma', 1.0, min = NA, max = NA, step = 1),
            numericInput('chdir_nnull', 'Nnull', 10, min = 1, max = 1000, step = 1),
            actionButton(inputId = 'run_chdir', label = 'Run Characteristic Direction Analysis', icon = NULL)
        )),
        column(4, wellPanel(
            h4('chdir results', id='chdir_results'),
            tags$dl(
                tags$dt('#{significant genes}:'),
                tags$dd(textOutput('n_sig_genes'))
            ),
            downloadButton('download_chdir', 'Download chdir'),
            downloadButton('download_chdir_up', 'Download up genes'),
            downloadButton('download_chdir_down', 'Download down genes')
        ))
        ),
        column(12, ggvisOutput("ggvis"))
    )
)


#' Principle Angle Enrichment Analysis ouput tab
#'
paea_tab <- tabPanel(
    'Principle Angle Enrichment Analysis',
    fluidRow(
        column(12, p('')),
        column(12, wellPanel(
            actionButton(inputId = 'run_paea', label = 'Run Principle Angle Enrichment', icon = NULL)
        )),
        column(12, h4('PAEA results')),
        column(12, dataTableOutput('pae_results'))
    )
)


#' Data analysis tab
#'
analyze_panel <- tabPanel(
    title='Analyze',
    tabsetPanel(
        id='workflow_panel',
        upload_tab,
        chdir_tab,
        paea_tab
    )
)

#' About tab
#'
about_panel <- tabPanel(
    title = 'About',
    fluidRow(column(12))
)


#' Complete UI
#'
shinyUI(
    navbarPage(
        title='NASB Microtask Viewer',
        analyze_panel,
        about_panel,
        includeCSS('www/css/tourist.css'),
        tags$script(src='js/underscore-min.js'),
        tags$script(src='js/backbone-min.js'),
        includeScript('www/js/tourist.min.js'),
        includeScript('www/js/analyze-tour.js')
    )
)