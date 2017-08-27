--★吸血鬼の形身　万里ちさと
function c114100490.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c114100490.ffilter1,c114100490.ffilter2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c114100490.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114100490.spcon)
	e2:SetOperation(c114100490.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c114100490.tgcon)
	e3:SetTarget(c114100490.tgtg)
	e3:SetOperation(c114100490.tgop)
	c:RegisterEffect(e3)
end
function c114100490.ffilter1(c)
	return c:IsSetCard(0x221)
end
function c114100490.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c114100490.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c114100490.costfilter2(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and not c:IsCode(114100490) and c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost() 
end
function c114100490.costfilter1(c,lv)
	return c:IsSetCard(0x221) and c:IsAbleToRemoveAsCost() and not c:IsCode(114100490) and c:IsLevelBelow(lv)
end
function c114100490.pfilter1(c,m,ct)
	if not c114100490.costfilter2(c) then return false end
	local lv=9
	local clv=c:GetLevel()
	lv=lv-clv
	if ct>=0 and c:IsLocation(LOCATION_MZONE) then ct=ct-1 end
	if lv>0 then
		local cg={}
		cg[1]=c:GetLevel()
		local mg=m
		if mg:IsContains(c) then mg:RemoveCard(c) end
		return mg:IsExists(c114100490.pfilter2,1,nil,mg,ct,lv,cg,1,clv) 
	else
		if ct<0 then
			return true
		else
			return false
		end
	end
end
function c114100490.pfilter2(c,m,ct,lv,cg,count,sum)
	if ct>=0 and not c:IsLocation(LOCATION_MZONE) then return false end
	local clv=c:GetLevel()
	local count2=count+1
	local cg2=cg
	cg2[count2]=clv
	local ct2=ct
	if ct>=0 and c:IsLocation(LOCATION_MZONE) then ct2=ct-1 end
	local sum2=sum+clv
	if clv>=lv then 
		local check=true
		--check combination
		for i=1,count2 do
			if sum2-cg2[i]>=9 then 
				check=false break
			end
		end
		return check
	else
		local mg=m:Clone()
		mg:RemoveCard(c)
		mg=mg:Filter(Card.IsLevelBelow,nil,lv-1)
		local lv2=lv-clv
		return mg:IsExists(c114100490.pfilter2,1,nil,mg,ct2,lv2,cg2,count2,sum2)
	end
end
function c114100490.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	--check space
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<0 then ct=-1 end
	--create remove group
	local g=Duel.GetMatchingGroup(c114100490.costfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,8)
	--fusion check "fusion card"
	return Duel.IsExistingMatchingCard(c114100490.pfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,g,ct)
end
function c114100490.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--check space
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<0 then ct=-1 end
	--
	local g=Duel.GetMatchingGroup(c114100490.costfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,8)
	local mg=Duel.GetMatchingGroup(c114100490.pfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,g,ct)
	local sg1=mg:Select(tp,1,1,nil)
	local sg1tg=sg1:GetFirst()
	if g:IsContains(sg1tg) then g:RemoveCard(sg1tg) end
	local lv=9
	local clv=sg1tg:GetLevel()
	lv=lv-clv
	local cg={}
	cg[1]=clv
	local count=1
	local sum2=clv
	while lv>0 do
		local sg2=g:FilterSelect(tp,c114100490.pfilter2,1,1,nil,g,ct,lv,cg,count,sum2)
		local sg2tg=sg2:GetFirst()
		if ct>=0 and sg2tg:IsLocation(LOCATION_MZONE) then ct=ct-1 end
		local clv2=sg2tg:GetLevel()
		if clv<lv then g=g:Filter(Card.IsLevelBelow,nil,lv-1) end
		lv=lv-clv2
		g:RemoveCard(sg2tg)
		sg1:Merge(sg2)
		sum2=sum2+clv2
		--
		count=count+1
		cg[count]=clv2
		--
	end
	--operation
	Duel.Remove(sg1,POS_FACEUP,REASON_COST)
end
--to grave
function c114100490.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
end
function c114100490.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c114100490.fdfilter(c,tp)
	return c:IsType(TYPE_FIELD) and ( c:GetActivateEffect():IsActivatable(tp) or c:IsAbleToHand() )
end
function c114100490.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100490.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c114100490.fdfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c114100490.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c114100490.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c114100490.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local tc=Duel.SelectMatchingCard(tp,c114100490.fdfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			--option check
			local chc=0
			if tc:IsAbleToHand() then chc=chc+1 end
			if tc:GetActivateEffect():IsActivatable(tp) then chc=chc+2 end
			local opt=-1
			if chc==1 then
				opt=0
			else if chc==2 then
					opt=1
				else
					opt=2
				end
			end
			--option select
			if opt==2 then opt=Duel.SelectOption(tp,aux.Stringid(114100490,0),aux.Stringid(114100490,1)) end
			if opt==0 then 
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end