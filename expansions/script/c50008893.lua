--New·New Stars
local m=50008893
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c50008893.target)
    e1:SetOperation(c50008893.activate)
    c:RegisterEffect(e1)
    --dr
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,50008893)
    e3:SetCondition(c50008893.drcon)
    e3:SetTarget(c50008893.drtg)
    e3:SetOperation(c50008893.drop)
    c:RegisterEffect(e3)
end
function c50008893.filter(c,e,tp,m,ft)
    if not c:IsSetCard(0x50b) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
    else
        return mg:IsExists(c50008893.filterF,1,nil,tp,mg,c)
    end
end
function c50008893.filterF(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
    else return false end
end
function c50008893.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetMZoneCount(tp)
        return ft>-1 and Duel.IsExistingMatchingCard(c50008893.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c50008893.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetMZoneCount(tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c50008893.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,c50008893.filterF,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
---
function c50008893.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(0x50b)
end
function c50008893.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50008893.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.ShuffleHand(p)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(p,Card.IsSetCard,p,LOCATION_HAND,0,1,1,nil,0x50b)
    local tg=g:GetFirst()
    if tg then
        if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then
            Duel.ConfirmCards(1-p,tg)
            Duel.ShuffleHand(p)
        end
    else
        local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end