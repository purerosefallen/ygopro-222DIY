--自由斗士·面具的V
function c10131006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c10131006.reptg)
	e1:SetValue(c10131006.repval)
	e1:SetOperation(c10131006.repop)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131006,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,10131006)
	e2:SetCondition(c10131006.drcon)
	e2:SetTarget(c10131006.drtg)
	e2:SetOperation(c10131006.drop)
	c:RegisterEffect(e2) 
end
function c10131006.drfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsSetCard(0x5338) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c10131006.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10131006.drfilter,1,nil,tp)
end
function c10131006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10131006.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x5338) then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10131006,2)) then
				Duel.BreakEffect()
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function c10131006.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x5338)
		and c:IsReason(REASON_EFFECT)
end
function c10131006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10131006.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) and Duel.CheckLPCost(tp,500) end
	return Duel.SelectYesNo(tp,aux.Stringid(10131006,0))
end
function c10131006.repval(e,c)
	return c10131006.filter(c,e:GetHandlerPlayer())
end
function c10131006.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10131006)
	Duel.PayLPCost(tp,500)
end
