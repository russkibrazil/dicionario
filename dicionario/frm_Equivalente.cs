﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using dicionario.Model;
using dicionario.Helpers;

namespace dicionario
{
    public partial class frm_Equivalente : Form
    {
        private CRUD crud = new CRUD();
        private List<Equivalente> equivO = new List<Equivalente>();
        private List<Equivalente> equivD = new List<Equivalente>();
        private List<Palavra> resP = new List<Palavra>();
        private List<MarcaUso> resRubrica = new List<MarcaUso>();
        private List<Referencia> resRef = new List<Referencia>();
        private readonly Palavra registroPai;
        private Equivalente oldEqAt;
        private Equivalente ativo = new Equivalente();
        private bool regsAtivo = true;
        private int posLista = 0;
        private bool novo = false;
        private bool equivDestModificado = false;

        public frm_Equivalente(Palavra registroPai)
        {
            this.registroPai = registroPai;
            InitializeComponent();
        }

        private void configuraLabelOrgiem(Palavra item)
        {
            lblOrigem.Text = item.lema;
        }

        private void MostraRegistroAtivo()
        {
            chkHtonico.Checked = ativo.heterotonico;
            chkHsemantico.Checked = ativo.heterossemantico;
            chkHgenerico.Checked = ativo.heterogenerico;

            resP = Palavra.ConverteObject(crud.SelecionarTabela(tabelasBd.PALAVRA, Palavra.ToListTabela(true), "id="+ativo.equivalente.ToString()));
            comboDestino.Text = resP.First().lema;

            txtApresentacao.Value = ativo.nOrdem;
            txtExemplo.Text = ativo.exemplo;
            txtExemploTraduzido.Text = ativo.exemplo_traduzido;

            resRef = Referencia.ConverteObject(crud.SelecionarTabela(tabelasBd.REFERENCIAS, Referencia.ToListTabela(true), "Id=" + ativo.Referencia.ToString()));
            if (resRef.Count > 0)
                comboRef.Text = resRef.First().descricao;

            resRubrica = MarcaUso.ConverteObject(crud.SelecionarTabela(tabelasBd.MARCAS_USO, MarcaUso.ToListTabela(true), "Id="+ativo.MarcaUso.ToString()));
            if (resRubrica.Count > 0)
                ComboRubrica.Text = resRubrica.First().descricao;
            oldEqAt = ativo;
            txtCultura.Text = ativo.notasCulturais;
            txtGramatica.Text = ativo.notasGramaticais;
        }

        private void LimpaCampos()
        {
            chkHtonico.Checked = false;
            chkHsemantico.Checked = false;
            chkHgenerico.Checked = false;
            comboDestino.Text = "";
            comboDestino.Items.Clear();
            comboRef.Items.Clear();
            comboRef.Text = "";
            ComboRubrica.Items.Clear();
            ComboRubrica.Text = "";
            txtApresentacao.Value = 1;
            txtExemploTraduzido.Text = "";
            txtExemplo.Text = "";
            ativo.Invalidarequivalente();
            txtCultura.Text = "";
            txtGramatica.Text = "";
        }

        private void frm_Equivalente_Load(object sender, EventArgs e)
        {
            configuraLabelOrgiem(registroPai);
            equivO = Equivalente.ConverteObject(crud.SelecionarTabela(tabelasBd.EQUIVALENTE, Equivalente.ToListTabela(), "Origem="+ registroPai.id.ToString(),"ORDER BY nApresentacao ASC"));
            //equivD = Equivalente.ConverteObject(crud.SelecionarTabela(tabelasBd.EQUIVALENTE, Equivalente.ToListTabela(), "equivalente=" + registroPai.id.ToString()));
            if (equivO.Count > 0)
            {
                posLista++;
                btnPrimeiro_Click(sender, e);
                if (equivO.Count > 1)
                    AtivaNavegadores();
            }
            else
            {
                btnNovo_Click(sender, e);
            }
        }

        private void AtivaNavegadores(){
            btnAnterior.Enabled = true;
            btnProximo.Enabled = true;
            btnPrimeiro.Enabled = true;
            btnUltimo.Enabled = true;
        }
        private void DesativaNavegadores(){
            btnAnterior.Enabled = false;
            btnProximo.Enabled = false;
            btnPrimeiro.Enabled = false;
            btnUltimo.Enabled = false;
        }
        
        private void btnPrimeiro_Click(object sender, EventArgs e)
        {
            if (posLista > 0)
            {
                posLista = 0;
                if (regsAtivo)
                {
                    ativo = equivO.First();
                }
                else
                {
                    ativo = equivD.First();
                }
                MostraRegistroAtivo();
            }
        }

        private void btnAnterior_Click(object sender, EventArgs e)
        {
            if (posLista > 0)
            {
                posLista--;
                if (regsAtivo)
                {
                    ativo = equivO.ElementAt(posLista);
                }
                else
                {
                    ativo = equivD.ElementAt(posLista);
                }
                MostraRegistroAtivo();
            }
        }

        private void btnProximo_Click(object sender, EventArgs e)
        {
            if (regsAtivo)
            {
                if (posLista < (equivO.Count -1))
                {
                    ativo = equivO.ElementAt(++posLista);
                }

            }
            else
            {
                if (posLista < (equivD.Count-1))
                {
                    ativo = equivD.ElementAt(++posLista);
                }
            }
            MostraRegistroAtivo();
        }

        private void btnUltimo_Click(object sender, EventArgs e)
        {
            if (regsAtivo)
            {
                if (posLista < equivO.Count)
                {
                    ativo = equivO.Last();
                    posLista = equivO.Count - 1;
                }
            }
            else
            {
                if (posLista < equivD.Count)
                {
                    ativo = equivD.Last();
                    posLista = equivD.Count - 1;
                }
            }
            MostraRegistroAtivo();
        }
        private void btnNovo_Click (object sender, EventArgs e)
        {
            LimpaCampos();
            ativo.SetOrigem(registroPai.id);
            novo = true;
        }

        private void btnApaga_Click(object sender, EventArgs e){
            if (InformaDiag.ConfirmaSN("Deseja realmente apagar o relacionamento?\nA ação é irreversível!") == DialogResult.Yes)
            {
                crud.ApagaLinha(tabelasBd.EQUIVALENTE, "origem=" + ativo.origem.ToString() + " AND equivalente=" + ativo.equivalente.ToString());
                equivO.Remove(ativo);
                if (equivO.Count >= 1)
                {
                    btnPrimeiro_Click(sender, e);
                }
                else
                {
                    LimpaCampos();
                }
            }
            
        }

        private void btnSalva_Click(object sender, EventArgs e)
        {
            if (equivDestModificado || ativo.equivalente < 1)
            {
                if (novo)
                {
                    InformaDiag.Erro("Selecione uma palavra equivalente dentro dos\nresultados da caixa de pesquisa Verbete Destino!");
                    return;
                }
                else
                {
                    if (InformaDiag.ConfirmaSN("O valor selecionado no verbete destino foi modificado para um valor inconsistente.\nDeseja continuar com o valor antigo?") == DialogResult.No)
                        return;
                }
            }
            ativo.exemplo = txtExemplo.Text;
            ativo.exemplo_traduzido = txtExemploTraduzido.Text;
            ativo.DefinirOrdemApresentação((int)txtApresentacao.Value);
            ativo.heterogenerico = chkHgenerico.Checked;
            ativo.heterotonico = chkHtonico.Checked;
            ativo.heterossemantico = chkHsemantico.Checked;
            ativo.notasCulturais = txtCultura.Text;
            ativo.notasGramaticais = txtGramatica.Text;
            if (!novo)
            {
                crud.UpdateLine(tabelasBd.EQUIVALENTE, Equivalente.ToListTabela(), ativo.ToListValores(), "Origem=" + oldEqAt.origem.ToString() +" AND equivalente=" + oldEqAt.equivalente.ToString() +" AND nApresentacao=" + oldEqAt.nOrdem.ToString());
                int tpos = equivO.IndexOf(ativo);
                equivO.RemoveAt(tpos);
                equivO.Insert(tpos, ativo);
            }
            else
            {
                crud.InsereLinha(tabelasBd.EQUIVALENTE, Equivalente.ToListTabela(), ativo.ToListValores());
                equivO.Add(ativo);
                if (equivO.Count > 1)
                    AtivaNavegadores();
            }
            InformaDiag.InformaSalvo();
            novo = false;
        }

        private void btnVisao_Click(object sender, EventArgs e){
            if (regsAtivo)
            {
                regsAtivo = false;
                ativo = equivD.First();
                btnVisao.Text = "Mostrar ativos";
            }
            else
            {
                regsAtivo = true;
                ativo = equivO.First();
                btnVisao.Text = "Mostrar estrangeiros";
            }
            MostraRegistroAtivo();
        }

        private void timerDestino_Tick(object sender, EventArgs e)
        {
            string pesquisa = comboDestino.Text;
            comboDestino.Items.Clear();
            if (pesquisa.Length > 0)
            {
                resP = Palavra.ConverteObject(crud.SelecionarTabela(tabelasBd.PALAVRA, Palavra.ToListTabela(true), "lema='" + pesquisa + "'", "LIMIT 25"));
                foreach (Palavra p in resP)
                {
                    comboDestino.Items.Add(p.lema + " Idioma " + p.idioma + ", " + p.ClasseGram + " " + p.Genero);
                }
            }
            timerDestino.Enabled = false;
        }

        private void comboDestino_TextUpdate(object sender, EventArgs e)
        {
            if (timerDestino.Enabled)
            {
                timerDestino.Enabled = false;
                timerDestino.Enabled = true;
            } else
            {
                timerDestino.Enabled = true;
            }
            equivDestModificado = true;
        }

        private void comboDestino_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboDestino.Text != "")
            {
                ativo.Setequivalente(resP.ElementAt(comboDestino.SelectedIndex).id);
                equivDestModificado = false;
            }
        }

        private void timerRub_Tick(object sender, EventArgs e)
        {
            string pesquisa;
            pesquisa = ComboRubrica.Text;
            if (ComboRubrica.Items.Count > 0)
            {
                ComboRubrica.Items.Clear();
            }
            if (pesquisa.Length <= 3)
            {
                resRubrica = MarcaUso.ConverteObject(crud.SelecionarTabela(tabelasBd.MARCAS_USO, MarcaUso.ToListTabela(true), "sigla LIKE '" + pesquisa + "%'", "LIMIT 10"));
            }
            else
                resRubrica = MarcaUso.ConverteObject(crud.SelecionarTabela(tabelasBd.MARCAS_USO, MarcaUso.ToListTabela(true), "descricao LIKE '" + pesquisa + "%'", "LIMIT 10"));
            foreach (MarcaUso r in resRubrica)
            {
                ComboRubrica.Items.Add(r.descricao);
            }
            timerRub.Enabled = false; //prevenindo de floodar a combo
        }

        private void ComboRubrica_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ComboRubrica.Text != "")
            {
                ativo.MarcaUso = resRubrica.Find(rubrica => rubrica.descricao == ComboRubrica.Text).id;
            }
        }

        private void ComboRubrica_TextUpdate(object sender, EventArgs e)
        {
            if (timerRub.Enabled == true) { timerRub.Enabled = false; timerRub.Enabled = true; } else timerRub.Enabled = true;
        }

        private void timerRef_Tick(object sender, EventArgs e)
        {
            string pesquisa;
            pesquisa = comboRef.Text;
            if (comboRef.Items.Count > 0)
            {
                comboRef.Items.Clear();
            }
            if (pesquisa.Length >= 5)
            {
                resRef = Referencia.ConverteObject(crud.SelecionarTabela(tabelasBd.REFERENCIAS, Referencia.ToListTabela(true), "Descricao LIKE '%" + pesquisa + "%'", "LIMIT 10"));
                foreach (Referencia re in resRef)
                {
                    comboRef.Items.Add(re.descricao);
                }
            }
            /*else
                resultados = crud.SelecionarTabela("referencias", Referencia.ToListTabela(true), "descricao LIKE '" + pesquisa + "%'", "LIMIT 10");*/
            timerRef.Enabled = false; //prevenindo de floodar a combo
        }

        private void comboRef_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboRef.Text != "")
            {
                ativo.Referencia = resRef.Find(r => r.descricao == comboRef.Text).id;
            }
        }

        private void comboRef_TextUpdate(object sender, EventArgs e)
        {
            if (timerRef.Enabled == true) { timerRef.Enabled = false; timerRef.Enabled = true; } else timerRef.Enabled = true;
        }
    }
}
