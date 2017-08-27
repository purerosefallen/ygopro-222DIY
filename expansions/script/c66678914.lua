--忘却之海·永恒冻结
function c66678914.initial_effect(c)
	c:SetUniqueOnField(1,0,66678914,LOCATION_MZONE)
	--Xyz
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,5,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
		Duel.SetChainLimit(function(e,ep,tp)
			return tp==ep and e:IsActiveType(TYPE_MONSTER)
		end)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(function(c,e)
			return c:IsFaceup() and c:IsRelateToEffect(e)
		end,nil,e)
		if c:IsRelateToEffect(e) and tg:GetCount()~=0 then
			local tc=tg:GetFirst()
			while tc do
				c:SetCardTarget(tc)
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetCondition(function(e)
					return e:GetOwner():IsHasCardTarget(e:GetHandler())
				end)
				tc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE)
				tc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e3,true)
				local t={
					EFFECT_UNRELEASABLE_SUM,
					EFFECT_UNRELEASABLE_NONSUM,
					EFFECT_CANNOT_BE_FUSION_MATERIAL,
					EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,
					EFFECT_CANNOT_BE_XYZ_MATERIAL
				}
				for i,code in pairs(t) do
					local te=e3:Clone()
					te:SetCode(code)
					te:SetValue(1)
					tc:RegisterEffect(te,true)
				end
				tc=tg:GetNext()
			end
		end
	end)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
			and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c66678914.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66678914.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e4)
end
function c66678914.thfilter(c)
	return c:IsSetCard(0x665)  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
