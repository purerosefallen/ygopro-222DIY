--小天使
function c17060882.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060882,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c17060882.descon)
	e1:SetTarget(c17060882.reptg)
	e1:SetValue(c17060882.repval)
	e1:SetOperation(c17060882.repop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c17060882.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060882,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1,17060882)
	e3:SetCondition(c17060882.rmcon)
	e3:SetTarget(c17060882.rmtg)
	e3:SetOperation(c17060882.rmop)
	c:RegisterEffect(e3)
end
function c17060882.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c17060882.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c17060882.repfilter(c,tp,hc)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and (c:IsControler(tp) or c:IsControler(1-tp)) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and hc:GetLinkedGroup():IsContains(c)
end
function c17060882.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	or (Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1))) 
	and eg:IsExists(c17060882.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectYesNo(tp,aux.Stringid(17060882,2))
end
function c17060882.repval(e,c)
	return c17060882.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c17060882.psfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060882.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060882.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local b2=(Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1))
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(17060882,3),aux.Stringid(17060882,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(17060882,3))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(17060882,4))+1
	else return end
	if op==0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else 
		Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060882.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c17060882.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetLabelObject(),1,0,0)
end
function c17060882.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.GetControl(bc,tp)
	end
end
