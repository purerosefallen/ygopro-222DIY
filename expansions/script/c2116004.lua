--迷惘的少女
function c2116004.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp
	end)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local fil=function(c) return c:IsCode(2116000,2116002,2116003) and c:IsAbleToRemoveAsCost() end
		if chk==0 then return Duel.IsExistingMatchingCard(fil,tp,LOCATION_GRAVE,0,1,nil)
			and c:GetFlagEffect(2116004)==0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,fil,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:RegisterFlagEffect(2116004,RESET_CHAIN,0,1)
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local pos=0
		if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
		if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
		if pos==0 then return end
		if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
			Duel.Summon(tp,c,true,nil,1)
		else
			Duel.MSet(tp,c,true,nil,1)
		end
	end)
	c:RegisterEffect(e4)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetFlagEffect(2116005)==0 end
		c:RegisterFlagEffect(2116005,RESET_CHAIN,0,1)
	end)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp
	end)
	e1:SetTarget(c2116004.target)
	e1:SetOperation(c2116004.operation)
	c:RegisterEffect(e1)
end
function c2116004.filter(c,e,tp,lv1)
	local lv2=c:GetLevel()
	return lv1>0 and lv2>0 and c:IsCode(2116000) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c2116004.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv1+lv2)
end
function c2116004.exfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2116004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2116004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2116004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsAbleToRemove() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c2116004.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c:GetLevel())
	local lv=rg:GetFirst():GetLevel()+c:GetLevel()
	rg:AddCard(c)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c2116004.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end