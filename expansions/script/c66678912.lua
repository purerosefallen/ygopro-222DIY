--忘却之海·东条希
function c66678912.initial_effect(c)
	--Xyz
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),5,3)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(c66678912.filter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not (Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(c66678912.filter,tp,LOCATION_GRAVE,0,1,nil)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c66678912.filter,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:GetCount()==0 then return end
		if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return eg:IsExists(c66678912.tfilter,1,e:GetHandler(),tp) end
		local g=eg:Filter(c66678912.tfilter,nil,tp)
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(c66678912.filter2,nil,e,tp)
		if Duel.GetMZoneCount(tp)<g:GetCount() then return end
		local tc=g:GetFirst()
		while tc do
			if Duel.GetControl(tc,tp,PHASE_END,1) then
			elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
				Duel.Destroy(tc,REASON_EFFECT)
			end
			tc=g:GetNext()
		end
	end)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
			and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end)
	c:RegisterEffect(e4)
end
function c66678912.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsControlerCanBeChanged() and c:GetSummonPlayer()==1-tp
end
function c66678912.tfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsControlerCanBeChanged() and c:GetSummonPlayer()==1-tp
end
function c66678912.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck()
end
