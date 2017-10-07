--圣灵依少女
local m=50000210
local cm=_G["c"..m]
function cm.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c50000210.ffilter,2,false)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000210,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCost(c50000210.spcost)
    e1:SetTarget(c50000210.sptg)
    e1:SetOperation(c50000210.spop)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000210,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,50000210)
    e2:SetTarget(c50000210.thtg)
    e2:SetOperation(c50000210.thop)
    c:RegisterEffect(e2)
end
c50000210.is_named_with_Rely=1
function c50000210.IsRely(c)
    local code=c:GetCode()
    local mt=_G["c"..code]
    if not mt then
        _G["c"..code]={}
        if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
            mt=_G["c"..code]
            _G["c"..code]=nil
        else
            _G["c"..code]=nil
            return false
        end
    end
    return mt and mt.is_named_with_Rely
end
function c50000210.ffilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000210.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupEx(tp,c50000210.ffilter,2,nil) end
    local g=Duel.SelectReleaseGroupEx(tp,c50000210.ffilter,2,2,nil)
    Duel.Release(g,REASON_COST)
end
function c50000210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000210.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if c:IsRelateToEffect(e) then
        local sp=Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
        c:CompleteProcedure()
    end
end

function c50000210.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c50000210.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000210.filter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c50000210.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50000210.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end