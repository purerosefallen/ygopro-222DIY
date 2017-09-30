--污浊的外装 泣哭的人鱼
function c11200007.initial_effect(c)
	 c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,11200007)
  --spsummon con
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11200007.splimit)
	c:RegisterEffect(e1)
 --effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c11200007.cost)
	e2:SetTarget(c11200007.target)
	e2:SetOperation(c11200007.operation)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c11200007.tgtg)
	e3:SetOperation(c11200007.tgop)
	c:RegisterEffect(e3)	
end
function c11200007.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x134)
end
function c11200007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	 Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200007.lovefilter(c)
	if not  (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) then return false end
	return c:IsCode(11200011) and  c:IsSSetable() 
end
function c11200007.betrayfilter(c)
	return c:IsCode(11200012) and ((c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave()) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
function c11200007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11200007.lovefilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c11200007.betrayfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(11200007,0),aux.Stringid(11200007,1),aux.Stringid(11200007,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(11200007,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(11200007,1))+1
	end
	e:SetLabel(opt)
	if opt==1 then
		e:SetCategory(0)
	end
end
function c11200007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==0 or opt==2 then
		local ssg=Duel.GetMatchingGroup(c11200007.lovefilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
		if ssg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local seg=ssg:Select(tp,1,1,nil)
			Duel.SSet(tp,seg)
			Duel.ConfirmCards(1-tp,seg)
			local ssgt=seg:GetFirst()
			ssgt:SetStatus(STATUS_SET_TURN,false)
		end
	end
	if opt==1 or opt==2 then
		local stg=Duel.GetMatchingGroup(c11200007.betrayfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
		if stg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=stg:Select(tp,1,1,nil)
			if sg:GetFirst():IsLocation(LOCATION_DECK) then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			else
		  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		end
	 end
  end
end
function c11200007.spfilter(c,e,tp)
	return c:IsSetCard(0x134) and not c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c11200007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11200007.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c11200007.tgop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11200007.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e1)
		end
end