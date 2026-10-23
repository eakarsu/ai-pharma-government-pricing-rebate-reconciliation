// Feature pack: search/filter, export, and deterministic domain insights over own records.
// No provider call is made here; insights are a labelled deterministic fallback.
export const INSIGHT_LABELS = ["Government pricing variance", "Rebate liability exposure", "Restatement readiness"];
const CLOSED = new Set(["approved","closed","done","cancelled"]);
export function recordStatus(row){ return String(row?.status ?? row?.state ?? ""); }
export function parseListQuery(query={}){ return { q:String(query.q||"").trim(), status:String(query.status||"").trim(), risk:String(query.risk||"").trim() }; }
export function filterRecords(rows, query={}){
  const {q,status,risk}=parseListQuery(query); const needle=q.toLowerCase();
  return (rows||[]).filter(row=>{
    if(status && recordStatus(row).toLowerCase()!==status.toLowerCase()) return false;
    if(risk && String(row?.risk||"").toLowerCase()!==risk.toLowerCase()) return false;
    if(needle && !JSON.stringify(row??{}).toLowerCase().includes(needle)) return false;
    return true;
  });
}
function csvCell(v){ if(v===null||v===undefined) return ""; const s=typeof v==="object"?JSON.stringify(v):String(v); return /[",\n]/.test(s)?'"'+s.replaceAll('"','""')+'"':s; }
export function recordsToCsv(rows){
  const cols=[...new Set((rows||[]).flatMap(r=>Object.keys(r||{})))];
  if(!cols.length) return "";
  return [cols.join(","), ...(rows||[]).map(r=>cols.map(c=>csvCell(r?.[c])).join(","))].join("\n")+"\n";
}
export function formatExport(rows, format){
  if(String(format||"json").toLowerCase()==="csv") return {contentType:"text/csv; charset=utf-8", body:recordsToCsv(rows), filename:"records.csv"};
  return {contentType:"application/json; charset=utf-8", body:JSON.stringify({items:rows||[]},null,2), filename:"records.json"};
}
export function buildInsights(rows){
  const list=rows||[]; const total=list.length;
  const open=list.filter(r=>!CLOSED.has(recordStatus(r).toLowerCase())).length;
  const highRisk=list.filter(r=>["high","critical"].includes(String(r?.risk||"").toLowerCase())).length;
  const totalAmount=list.reduce((s,r)=>s+(Number(r?.amount)||0),0);
  const sections=[
    {id:"insight-1", title:INSIGHT_LABELS[0], label:INSIGHT_LABELS[0], value:total, detail:`${total} record(s) in scope; ${open} still open. Deterministic count from your own records.`},
    {id:"insight-2", title:INSIGHT_LABELS[1], label:INSIGHT_LABELS[1], value:highRisk, detail:`${highRisk} high/critical-risk record(s) need evidence review. Zero means none flagged, not that risk was hidden.`},
    {id:"insight-3", title:INSIGHT_LABELS[2], label:INSIGHT_LABELS[2], value:totalAmount, detail:`Represented amount is ${totalAmount} across ${total} record(s); validate source evidence before acting.`},
  ];
  return { aiGenerated:false, source:"deterministic-fallback", label:"Deterministic fallback \u2014 no AI provider call", summary:{total, open, highRisk, totalAmount}, sections };
}
