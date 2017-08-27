--战后的整备 佐仓杏子
function c60152008.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152008,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6012008)
	e1:SetTarget(c60152008.target)
	e1:SetOperation(c60152008.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152008,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,60152008)
    e3:SetTarget(c60152008.sptg)
    e3:SetOperation(c60152008.spop)
    c:RegisterEffect(e3)
end
function c60152008.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152008.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60152008.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60152008.filter,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>0 then
		local atk=Duel.GetMatchingGroupCount(c60152008.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*200
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(atk)
            sc:RegisterEffect(e1)
			local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            sc:RegisterEffect(e2)
            sc=g:GetNext()
        end
    end
end
function c60152008.dfilter(c)
    return c:IsFacedown() and c:IsDestructable()
end
function c60152008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c60152008.dfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60152008.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c60152008.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60152008.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end