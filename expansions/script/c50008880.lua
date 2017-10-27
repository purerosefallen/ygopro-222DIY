--Stars 昴流
local m=50008880
local cm=_G["c"..m]
function cm.initial_effect(c)
    --remove atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008880,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,50008880)
    e1:SetCost(c50008880.cost)
    e1:SetOperation(c50008880.atkop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008880.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008880,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008880.spcon)
    e4:SetTarget(c50008880.sptg)
    e4:SetOperation(c50008880.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
    --draw
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(50008880,2))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_RELEASE)
    e5:SetCountLimit(1,500088801)
    e5:SetTarget(c50008880.drtg1)
    e5:SetOperation(c50008880.drop1)
    c:RegisterEffect(e5)
end
function c50008880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,2)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==2
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008880.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)    
    end
end
---
function c50008880.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) and rc:IsSetCard(0x50b) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008880,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008880.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008880)>0
end
function c50008880.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008880)
end
function c50008880.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
---

function c50008880.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50008880.drop1(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end