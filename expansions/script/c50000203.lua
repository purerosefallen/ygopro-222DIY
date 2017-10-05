--灵依法师－灵灭
function c50000203.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetDescription(aux.Stringid(50000203,0))
    e1:SetCode(EVENT_TO_DECK)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1)
    e1:SetCondition(c50000203.thcon)
    e1:SetTarget(c50000203.thtg)
    e1:SetOperation(c50000203.thop)
    c:RegisterEffect(e1)
    --Remove Monster
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetDescription(aux.Stringid(50000203,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,50000203)
    e2:SetCost(c50000203.cost)
    e2:SetTarget(c50000203.target)
    e2:SetOperation(c50000203.activate)
    c:RegisterEffect(e2)
    --ritual level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_RITUAL_LEVEL)
    e3:SetValue(c50000203.rlevel)
    c:RegisterEffect(e3)
    --Remove
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetDescription(aux.Stringid(50000203,2))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,500002031)
    e4:SetTarget(c50000203.retg)
    e4:SetOperation(c50000203.reop)
    c:RegisterEffect(e4)
end
c50000203.is_named_with_Rely=1
function c50000203.IsRely(c)
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
function c50000203.thfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) 
        and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c50000203.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c50000203.thfilter,1,nil,tp)
end
function c50000203.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(c50000203.thfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000203.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local rg=g:Select(tp,1,1,nil)
    if rg:GetCount()>0 then
        Duel.SendtoHand(rg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,rg)
    end
end
--remove
function c50000203.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50000203.cfilter,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectReleaseGroup(tp,c50000203.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50000203.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50000203.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
--ritual level
function c50000203.rlevel(e,c)
    local lv=e:GetHandler():GetLevel()
    if c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) then
        local clv=c:GetLevel()
        return lv*65536+clv
    else return lv end
end
--remove s+t
function c50000203.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_SZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_SZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50000203.reop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end