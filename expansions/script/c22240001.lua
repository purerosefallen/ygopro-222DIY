--Solid 零五六
function c22240001.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22240001,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,222400011)
	e3:SetCondition(c22240001.scon)
	e3:SetTarget(c22240001.stg)
	e3:SetOperation(c22240001.sop)
	c:RegisterEffect(e3)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,222400012)
	e1:SetCondition(c22240001.hspcon)
	e1:SetOperation(c22240001.hspop)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1)
	--Release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240001,1))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,222400013)
	e1:SetCondition(c22240001.relcon)
	e1:SetTarget(c22240001.reltg)
	e1:SetOperation(c22240001.relop)
	c:RegisterEffect(e1)
end
c22240001.named_with_Solid=1
function c22240001.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240001.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_SZONE)
end
function c22240001.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22240001.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c22240001.spfilter(c)
	return c:GetOriginalLevel()>3 and c:IsReleasable() and c22240001.IsSolid(c)
end
function c22240001.hspcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c22240001.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) or (Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22240001.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil))
end
function c22240001.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<1 then
		local g=Duel.SelectMatchingCard(tp,c22240001.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	elseif Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c22240001.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
end
function c22240001.relcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c22240001.relfilter(c,tp)
	return c:IsReleasableByEffect()
end
function c22240001.reltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsLocation(LOCATION_MZONE) and c22240001.relfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22240001.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c22240001.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c22240001.relop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
	end
end