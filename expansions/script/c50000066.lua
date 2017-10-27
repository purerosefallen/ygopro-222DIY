--暗之海贼 奇犽
function c50000066.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c50000066.linkfilter,2)
    c:EnableReviveLimit()
    --move
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000066,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,50000066)
    e1:SetCondition(c50000066.seqcon)
    e1:SetTarget(c50000066.seqtg)
    e1:SetOperation(c50000066.seqop)
    c:RegisterEffect(e1)
    --actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c50000066.aclimit)
    e2:SetCondition(c50000066.actcon)
    c:RegisterEffect(e2)
    --deck check
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50000066,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c50000066.checkcon)
    e3:SetTarget(c50000066.checktg)
    e3:SetOperation(c50000066.checkop)
    c:RegisterEffect(e3)
end
function c50000066.linkfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
----
function c50000066.seqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c50000066.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local scount=Duel.GetMZoneCount(tp)
    if scount==0 then return end
    return true
end
function c50000066.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler() 
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
    local nseq=0
    if s==1 then nseq=0
    elseif s==2 then nseq=1
    elseif s==4 then nseq=2
    elseif s==8 then nseq=3
    else nseq=4 end
    Duel.MoveSequence(c,nseq)
end
----
function c50000066.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c50000066.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
----
function c50000066.checkcon(e)
    return e:GetHandler():GetLinkedGroupCount()>0
end
function c50000066.checktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ccount = Duel.GetCounter(0,1,0,0x150c)-1
    if ccount < 1 then ccount=0 end
    if ccount == 0 then return end
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ccount  end
end
function c50000066.checkfilter(c,e,tp)
    return c:IsSetCard(0x50c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c50000066.checkop(e,tp,eg,ep,ev,re,r,rp)
    local ccount = Duel.GetCounter(0,1,0,0x150c)-1
    if ccount < 1 then ccount=0 end
    if ccount == 0 then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ccount then return end
    local g=Duel.GetDecktopGroup(tp,ccount)
    Duel.ConfirmCards(tp,g)
    if g:IsExists(c50000066.checkfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(50000066,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,c50000066.checkfilter,1,1,nil,e,tp)
        if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoGrave(sg,REASON_RULE)
        end
        Duel.ShuffleDeck(tp)
    else Duel.SortDecktop(tp,tp,ccount) end
end