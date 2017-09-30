--背叛的奏曲
function c11200012.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,11200008)
	e1:SetTarget(c11200012.target)
	e1:SetOperation(c11200012.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200012)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCost(c11200012.atkcost)
	e2:SetTarget(c11200012.atktg)
	e2:SetOperation(c11200012.atkop)
	c:RegisterEffect(e2)
end
function c11200012.filter(c)
	return c:IsSetCard(0x134) and c:IsAbleToGrave()
end
function c11200012.filter2(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c11200012.filter3(c)
	return  c:IsCode(11200007) and c:IsFaceup()
end
function c11200012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroup(c11200012.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local b2=Duel.GetMatchingGroup(c11200012.filter2,tp,LOCATION_EXTRA,0,nil)
	local b3=Duel.GetMatchingGroup(c11200012.filter3,tp,LOCATION_ONFIELD,0,nil)
	local draw=1
	if b3:GetCount()>0 then draw=2 end
	if chk==0 then
		return b1:GetCount()>0 and b2:GetCount()>0 and Duel.IsPlayerCanDraw(tp,draw)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,draw)
end
function c11200012.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetMatchingGroup(c11200012.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local b2=Duel.GetMatchingGroup(c11200012.filter2,tp,LOCATION_EXTRA,0,nil)
	if b1==nil or b2==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c11200012.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c11200012.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c11200012.filter3,tp,LOCATION_ONFIELD,0,1,nil) then
	Duel.BreakEffect() 
	Duel.Draw(tp,1,REASON_EFFECT) 
end
end
function c11200012.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11200012.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x134) and c:GetAttack()>0
end
function c11200012.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11200012.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200012.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g1=Duel.SelectTarget(tp,c11200012.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(11200012,0),aux.Stringid(11200012,1))
	e:SetLabel(opt)
end
function c11200012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tg=g:GetFirst()
		local atkp=tg:GetAttack()
		if atkp==0 then return end
		local opt=e:GetLabel()
		if opt==0 then 
			if Duel.Recover(tp,atkp,REASON_EFFECT)>0 then 
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetValue(0)
				tg:RegisterEffect(e1)
			end
		else
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-atkp)
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(tg:GetAttack()*2)
			tg:RegisterEffect(e1)
		end
	end
end