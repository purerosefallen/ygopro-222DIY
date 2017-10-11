--仙 境 的 古 圣 树 之 森
local m=46564059
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_ACTIVATE)
    e6:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e6)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.condition)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    --DE-fusion
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCountLimit(1,m-1000)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --to grave
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m-2000)
    e3:SetCost(cm.tgcost)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
end
function cm.dfilter(c)
    return c:IsSetCard(0x65c) and c:IsAbleToGraveAsCost()
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x65c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function cm.thfilter(c)
    return c:IsSetCard(0x65c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.mgfilter(c,e,tp,fusc,mg)
    return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
        and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and fusc:CheckFusionMaterial(mg,c)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
    local mg=tc:GetMaterial()
    local ct=mg:GetCount()
    local sumtype=tc:GetSummonType()
    if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
        and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
        and mg:FilterCount(aux.NecroValleyFilter(cm.mgfilter),nil,e,tp,tc,mg)==ct
        and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
        Duel.BreakEffect()
        Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.tgfilter(c)
    return c:IsSetCard(0x65c) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
