--★魔法少女マジカルワート
function c114000085.initial_effect(c)
	--on target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c114000085.cost)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000085.tgcon1)
	e1:SetTarget(c114000085.tgtg)
	e1:SetOperation(c114000085.tgop)
	c:RegisterEffect(e1)
	--on attack
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c114000085.tgcon2)
	c:RegisterEffect(e2)
end
--only once limit
function c114000085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114000085)==0 end
	Duel.RegisterFlagEffect(tp,114000085,RESET_PHASE+PHASE_END,0,1)
end
--condition
function c114000085.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()
		and ( tc:IsSetCard(0x223) or tc:IsSetCard(0x224) 
		or tc:IsCode(36405256) or tc:IsCode(54360049) or tc:IsCode(37160778) or tc:IsCode(27491571) or tc:IsCode(80741828) or tc:IsCode(90330453) or tc:IsCode(32751480) or tc:IsCode(78010363) or tc:IsCode(39432962) or tc:IsCode(67511500) or tc:IsCode(62379337) or tc:IsCode(23087070) or tc:IsCode(17720747) or tc:IsCode(98358303) or tc:IsCode(91584698)
		or tc:IsSetCard(0xcabb) )
end
function c114000085.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	if tp==Duel.GetTurnPlayer() then return false end
	local tc=Duel.GetAttackTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() 
	and ( tc:IsSetCard(0x223) or tc:IsSetCard(0x224) 
		or tc:IsCode(36405256) or tc:IsCode(54360049) or tc:IsCode(37160778) or tc:IsCode(27491571) or tc:IsCode(80741828) or tc:IsCode(90330453) --0x223
		or tc:IsCode(78010363) or tc:IsCode(39432962) or tc:IsCode(67511500) or tc:IsCode(62379337) or tc:IsCode(23087070) or tc:IsCode(98358303) or tc:IsCode(17720747) or tc:IsCode(32751480) or tc:IsCode(91584698) --0x224 
		or tc:IsSetCard(0xcabb) )
end
--sp summon
function c114000085.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000085.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetCurrentPhase()==PHASE_DRAW then
				e1:SetLabel(Duel.GetTurnCount())
			else
				e1:SetLabel(Duel.GetTurnCount()+2)
			end
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c114000085.retcon)
		e1:SetOperation(c114000085.retop)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			--one turn indestructable effect
			local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    	e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
			---ff0000 = RESET_LEAVE+RESET_TODECK+RESET_TOHAND+RESET_TEMP_REMOVE+ (f00000+)
			---         RESET_REMOVE+RESET_TOGRAVE+RESET_TURN_SET+RESET_DISABLE (0f0000)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			c:RegisterEffect(e3)
		end
	end
end
function c114000085.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c114000085.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end