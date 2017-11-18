--星彩的双星
local m=10902001
local cm=_G["c"..m]
function cm.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(3064425,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(59755122,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(cm.spcost)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(11493868,1))
    e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.activate)
    c:RegisterEffect(e3)
end
function cm.qfilter(c)
    return c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.qfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.qfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,cm.qfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(cm.eqlimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
end
function cm.eqlimit(e,c)
    return c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
    return ((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x235)) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
function cm.scfilter(c,g)
    return g:IsContains(c) and c:IsSetCard(0x235) and c:IsFaceup()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local cg=e:GetHandler():GetColumnGroup()
    if chkc then return chkc:IsOnField() and cm.scfilter(chkc,cg) end
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.scfilter,1,nil,cg) end
    local g=Duel.SelectReleaseGroup(tp,cm.scfilter,1,1,nil,cg)
    Duel.Release(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
