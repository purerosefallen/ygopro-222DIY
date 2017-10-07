--小馋喵 奇犽
function c50000056.initial_effect(c)
    --添加二重属性
    aux.EnableDualAttribute(c)
    --to grave
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000056,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetDescription(aux.Stringid(50000056,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(aux.IsDualState)
    e1:SetCountLimit(1,50000056)
    e1:SetTarget(c50000056.tgtg)
    e1:SetOperation(c50000056.tgop)
    c:RegisterEffect(e1)
    --attribute
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCondition(aux.IsDualState)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetValue(ATTRIBUTE_DARK)
    c:RegisterEffect(e2)
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(aux.IsDualState)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x50c))
    e3:SetValue(600)
    c:RegisterEffect(e3)
end
function c50000056.filter(c)
    return c:IsSetCard(0x50c) and not c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGrave()
end
function c50000056.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000056.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c50000056.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c50000056.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end