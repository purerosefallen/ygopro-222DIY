--东煌·逸仙
local m=10903003
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.spcon)
    c:RegisterEffect(e1)   
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1236))
    e2:SetCondition(cm.atkcon)
    e2:SetValue(800)
    c:RegisterEffect(e2) 
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)   
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_DISABLE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1236))
    e4:SetCondition(cm.atkcon)
    e4:SetValue(1)
    c:RegisterEffect(e4) 
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CHANGE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(0,1)
    e5:SetCondition(cm.valcon)
    e5:SetValue(cm.val)
    c:RegisterEffect(e5) 
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(51316684,0))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(cm.rmcon)
    e6:SetTarget(cm.destg)
    e6:SetOperation(cm.desop)
    c:RegisterEffect(e6) 
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_CHANGE_DAMAGE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(1,0)
    e7:SetValue(cm.val2)
    c:RegisterEffect(e7) 
end
function cm.spfilter(c)
    return c:IsFaceup() and c:IsCode(10903001)
end
function cm.spfilter2(c)
    return c:IsFaceup() and c:IsCode(10903002)
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkcon(e)
    return Duel.IsExistingMatchingCard(cm.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.valcon(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.filter2(c)
    return c:IsSetCard(0x1236) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.val(e,re,dam,r,rp,rc)
    return dam+Duel.GetMatchingGroupCount(cm.filter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*600
end
function cm.val2(e,re,dam,r,rp,rc)
    return dam-800 
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and e:GetHandler():GetBattledGroup():GetCount()>0 and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function cm.filter(c)
    return c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
        if tc:IsRelateToEffect(e) then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end
