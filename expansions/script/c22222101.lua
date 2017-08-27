--白泽球装甲
function c22222101.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c22222101.cbcon)
	e2:SetTarget(c22222101.cbtg)
	e2:SetOperation(c22222101.cbop)
	c:RegisterEffect(e2)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c22222101.target)
	e2:SetOperation(c22222101.activate)
	c:RegisterEffect(e2)



end
c22222101.named_with_Shirasawa_Tama=1
function c22222101.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22222101.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=eg:GetFirst()
	return c22222101.IsShirasawaTama(bt) and bt:IsControler(tp) and bt:IsFaceup()
end
function c22222101.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttacker():GetBaseAttack())
end
function c22222101.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,Duel.GetAttacker():GetBaseAttack(),REASON_EFFECT)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc and tc:IsAbleToRemove() do
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c22222101.reop)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()
	end
end
function c22222101.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22222101.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c22222101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22222101.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22222101.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetBaseAttack)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	
end
function c22222101.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22222101.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetBaseAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then Duel.Damage(sg:GetFirst():GetOwner(),1000,REASON_EFFECT) end

		else if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 then Duel.Damage(tg:GetFirst():GetOwner(),1000,REASON_EFFECT) end end
	end
end