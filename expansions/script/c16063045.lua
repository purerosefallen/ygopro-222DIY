--atuyi
function c16063045.initial_effect(c)
	--cannot atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c16063045.atkcon)
	c:RegisterEffect(e2)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c16063045.atop)
	c:RegisterEffect(e1)
	--Destroy and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16063045,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,16063045)
	e3:SetCondition(c16063045.descon)
	e3:SetTarget(c16063045.destg)
	e3:SetOperation(c16063045.desop)
	c:RegisterEffect(e3)
end
function c16063045.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER)
end
function c16063045.atkcon(e)
	return not Duel.IsExistingMatchingCard(c16063045.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c16063045.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c16063045.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063045.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function  c16063045.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and  c16063045.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063045.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063045.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function  c16063045.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) then
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end