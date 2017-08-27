--777-四季流转之歌
function c66677707.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,5)
	c:EnableReviveLimit()
	--c:SetUniqueOnField(1,0,66677707)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c66677707.atkval)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(c66677707.XMaterialCountCondition(2))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	e3:SetCondition(c66677707.XMaterialCountCondition(3))
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c66677707.XMaterialCountCondition(4))
	e4:SetValue(c66677707.efilter)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66677707,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp
	end)
	e3:SetTarget(c66677707.mttg)
	e3:SetOperation(c66677707.mtop)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(66677707,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c66677707.cost)
	e7:SetTarget(c66677707.destg)
	e7:SetOperation(c66677707.desop)
	c:RegisterEffect(e7)
end
function c66677707.ctfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c66677707.atkval(e,c)
	local atk=Duel.GetMatchingGroup(c66677707.ctfilter,c:GetControler(),LOCATION_REMOVED,0,nil):GetClassCount(Card.GetAttribute)*700
	if atk>2800 then atk=2800 end
	return atk
end
function c66677707.XMaterialCountCondition(ct)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetAttribute)>=ct
	end
end
function c66677707.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c66677707.mtfilter(c)
	return c:IsSetCard(0x777) and c:IsType(TYPE_MONSTER)
end
function c66677707.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66677707.mtfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c66677707.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c66677707.mtfilter,tp,LOCATION_HAND,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c66677707.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(66677707)==0 and Duel.IsExistingMatchingCard(c66677707.chk,tp,0,LOCATION_ONFIELD,1,nil,e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetAttribute)) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(Duel.GetOperatedGroup():GetClassCount(Card.GetAttribute))
	c:RegisterFlagEffect(66677707,RESET_CHAIN,0,1)
end
function c66677707.chk(c,xm)
	if xm<=0 then return false end
	if xm==1 then return true end
	if xm>=2 then return c:IsAbleToRemove() end
end
function c66677707.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local xm=e:GetLabel()
	if xm==1 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD) end
	if xm>=2 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD) end
end
function c66677707.eqfilter(c,code)
	return c:GetOriginalCode()==code and c:IsAbleToRemove()
end
function c66677707.desop(e,tp,eg,ep,ev,re,r,rp)
	local xm=e:GetLabel()
	if not Duel.IsExistingMatchingCard(c66677707.chk,tp,0,LOCATION_ONFIELD,1,nil,xm) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c66677707.chk,tp,0,LOCATION_ONFIELD,1,1,nil,xm)
	if xm==1 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	if xm>=2 then
		if xm>2 then
			for i=2,9 do
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(66677707,i))
			end
			local exg=Duel.GetMatchingGroup(c66677707.eqfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,nil)
			g:Merge(exg)
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end