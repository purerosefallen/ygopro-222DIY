--青鸟
function c10981040.initial_effect(c)
    --atk/lv up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10981040,1))
    e2:SetRange(LOCATION_MZONE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCost(c10981040.cost)
    e2:SetOperation(c10981040.operation)
    c:RegisterEffect(e2)   
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10981040,2))
    e3:SetRange(LOCATION_MZONE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCost(c10981040.cost2)
    e3:SetOperation(c10981040.operation2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10981040,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,10981040+EFFECT_COUNT_CODE_DUEL)
    e4:SetCondition(c10981040.condition)
    e4:SetTarget(c10981040.sptg)
    e4:SetOperation(c10981040.spop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCountLimit(1,10981041+EFFECT_COUNT_CODE_DUEL)
    e5:SetCondition(c10981040.condition2)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCountLimit(1,10981042+EFFECT_COUNT_CODE_DUEL)
    e6:SetCondition(c10981040.condition3)
    c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetCountLimit(1,10981043+EFFECT_COUNT_CODE_DUEL)
    e7:SetCondition(c10981040.condition4)
    c:RegisterEffect(e7)
    local e8=e4:Clone()
    e8:SetCountLimit(1,10981044+EFFECT_COUNT_CODE_DUEL)
    e8:SetCondition(c10981040.condition5)
    c:RegisterEffect(e8)
    local e9=e4:Clone()
    e9:SetCountLimit(1,10981045+EFFECT_COUNT_CODE_DUEL)
    e9:SetCondition(c10981040.condition6)
    c:RegisterEffect(e9)
    local e10=e4:Clone()
    e10:SetCountLimit(1,10981046+EFFECT_COUNT_CODE_DUEL)
    e10:SetCondition(c10981040.condition7)
    c:RegisterEffect(e10)
    local e11=e4:Clone()
    e11:SetCountLimit(1,10981047+EFFECT_COUNT_CODE_DUEL)
    e11:SetCondition(c10981040.condition8)
    c:RegisterEffect(e11)
    local e12=e4:Clone()
    e12:SetCountLimit(1,10981048+EFFECT_COUNT_CODE_DUEL)
    e12:SetCondition(c10981040.condition9)
    c:RegisterEffect(e12)
    local e13=e4:Clone()
    e13:SetCountLimit(1,10981049+EFFECT_COUNT_CODE_DUEL)
    e13:SetCondition(c10981040.condition10)
    c:RegisterEffect(e13)
    local e14=e4:Clone()
    e14:SetCountLimit(1,10981050+EFFECT_COUNT_CODE_DUEL)
    e14:SetCondition(c10981040.condition11)
    c:RegisterEffect(e14)
    local e15=e4:Clone()
    e15:SetCountLimit(1,10981051+EFFECT_COUNT_CODE_DUEL)
    e15:SetCondition(c10981040.condition12)
    c:RegisterEffect(e15)
end
function c10981040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10981040.cfilter(c)
    return c:IsRace(RACE_WINDBEAST) and c:IsAbleToRemoveAsCost()
end
function c10981040.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10981040.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c10981040.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10981040.filter(c,lv,e,tp)
    return c:GetLevel()==lv and c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10981040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c10981040.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetLevel(),e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10981040.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c10981040.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetLevel(),e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c10981040.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_LEVEL)
        e2:SetReset(RESET_EVENT+0x1ff0000)
        e2:SetValue(1)
        c:RegisterEffect(e2)
    end
end
function c10981040.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_LEVEL)
        e2:SetReset(RESET_EVENT+0x1ff0000)
        e2:SetValue(2)
        c:RegisterEffect(e2)
    end
end
function c10981040.condition(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==1
end
function c10981040.condition2(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==2
end
function c10981040.condition3(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==3
end
function c10981040.condition4(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==4
end
function c10981040.condition5(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==5
end
function c10981040.condition6(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==6
end
function c10981040.condition7(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==7
end
function c10981040.condition8(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==8
end
function c10981040.condition9(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==9
end
function c10981040.condition10(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==10
end
function c10981040.condition11(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==11
end
function c10981040.condition12(e,tp)
    local c=e:GetHandler()
    return c:GetLevel()==12
end