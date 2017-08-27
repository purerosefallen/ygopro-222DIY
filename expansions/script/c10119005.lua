--沉睡的季风
function c10119005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10119005,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10119005.target)
	e2:SetOperation(c10119005.operation)
	c:RegisterEffect(e2)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10119005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c10119005.sptg)
	e3:SetOperation(c10119005.spop)
	c:RegisterEffect(e3)
end

function c10119005.spfilter(c,e,tp)
	return c:IsSetCard(0x6331) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10119005.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end

function c10119005.mfilter1(c,mg,exg)
	return mg:IsExists(c10119005.mfilter2,1,c,c,exg)
end

function c10119005.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end

function c10119005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c10119005.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c10119005.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and exg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c10119005.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c10119005.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end

function c10119005.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10119005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10119005.spfilter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c10119005.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c10119005.sumfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_XYZ 
end
function c10119005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	  local tg=eg:Filter(c10119005.sumfilter,nil)
	  if tg:GetCount()<=0 then return false end
	  local tc=tg:GetFirst()
	  local mg=Group.CreateGroup()
	  local sg=nil
	  while tc do
		 sg=tc:GetMaterial()
		 if sg:GetCount()>0 then
		   mg:Merge(sg:Filter(c10119005.filter,nil,tp))
		 end
	  tc=tg:GetNext()
	  end
	   if mg:GetCount()>0 and Duel.IsExistingMatchingCard(c10119005.thfilter,tp,LOCATION_DECK,0,1,nil,mg) then
		  mg:KeepAlive()
		  e:SetLabelObject(mg)
	   return true
	   end
	return false
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10119005.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10119005.thfilter,tp,LOCATION_DECK,0,1,1,nil,mg)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c10119005.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x6331)
end

function c10119005.thfilter(c,mg)
	return c:IsSetCard(0x6331) and c:IsAbleToHand() and not mg:IsExists(Card.IsCode,1,nil,c:GetCode())
end

