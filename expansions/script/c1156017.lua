--蓬莱人的外形
function c1156017.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156017.lcheck,2,4)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156017,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1156017)
	e2:SetCondition(c1156017.con2)
	e2:SetOperation(c1156017.op2)
	c:RegisterEffect(e2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1156017.tg1)
	e1:SetOperation(c1156017.op1)
	c:RegisterEffect(e1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c1156017.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c1156017.op4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
--
end
--
function c1156017.lcheck(c)
	return c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
--
function c1156017.cfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c1156017.con2(e,c)
	if c==nil then return true end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c1156017.cfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
--
function c1156017.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c1156017.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,nil,REASON_COST)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e2_1,true)
end
--
function c1156017.tfilter1(c)
	return c:IsFaceup()
end
function c1156017.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c1156017.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1156017.tfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
end
--
function c1156017.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
--
function c1156017.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
--
function c1156017.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tc=g:GetFirst()
	local gn=Group.CreateGroup()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) then
			gn:AddCard(tc)
		end
		tc=g:GetNext()
	end
	if gn:GetCount()>0 then
		Duel.Destroy(gn,REASON_EFFECT)
	end
end
--


