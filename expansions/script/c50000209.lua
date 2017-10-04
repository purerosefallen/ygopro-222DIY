--灵依法师－灵璇
local m=50000209
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetDescription(aux.Stringid(50000209,0))
    e1:SetCode(EVENT_TO_DECK)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1)
    e1:SetCondition(c50000209.drcon)
    e1:SetTarget(c50000209.drtg)
    e1:SetOperation(c50000209.drop)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000209,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,50000209)
    e2:SetCost(c50000209.cost)
    e2:SetTarget(c50000209.thtg)
    e2:SetOperation(c50000209.thop)
    c:RegisterEffect(e2)
    --ritual level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_RITUAL_LEVEL)
    e3:SetValue(c50000209.rlevel)
    c:RegisterEffect(e3)
    --Remove
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetDescription(aux.Stringid(50000209,2))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,500002091)
    e4:SetTarget(c50000209.thtg1)
    e4:SetOperation(c50000209.thop1)
    c:RegisterEffect(e4)
end
c50000209.is_named_with_Rely=1
function c50000209.IsRely(c)
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
function c50000209.drfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) 
        and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c50000209.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c50000209.drfilter,1,nil,tp)
end
function c50000209.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000209.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
---
function c50000209.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50000209.cfilter,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectReleaseGroup(tp,c50000209.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50000209.filter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c50000209.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000209.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50000209.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c50000209.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000209.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
--ritual level
function c50000209.rlevel(e,c)
    local lv=e:GetHandler():GetLevel()
    if c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) then
        local clv=c:GetLevel()
        return lv*65536+clv
    else return lv end
end
---
function c50000209.thfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c50000209.IsRely(c) and c:IsAbleToHand()
end
function c50000209.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000209.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50000209.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c50000209.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000209.thop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end