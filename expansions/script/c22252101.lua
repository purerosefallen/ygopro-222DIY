--战时苏醒之力
function c22252101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,22252101+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22252101.condition)
	e1:SetOperation(c22252101.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22252101.cost)
	e2:SetTarget(c22252101.tg)
	e2:SetOperation(c22252101.op)
	c:RegisterEffect(e2)
end
c22252101.named_with_Riviera=1
function c22252101.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22252101.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c22252101.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c22252101.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c22252101.IsRiviera(c)
end
function c22252101.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if Duel.NegateAttack() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		local chkf=tp
		local mg1=g:Filter(Card.IsCanBeFusionMaterial,nil)
		local res=Duel.IsExistingMatchingCard(c22252101.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c22252101.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		if res and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22252101,0)) then 
			local mg1=g:Filter(Card.IsCanBeFusionMaterial,nil):Filter(c22252101.filter1,nil,e)
			local sg1=Duel.GetMatchingGroup(c22252101.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(c22252101.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
					tc:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP_ATTACK)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
				if tc:IsAttackable() and ac then
					Duel.CalculateDamage(tc,ac)
				end
			end
		end
	end
end
function c22252101.costfilter(c)
	return c:IsCode(22252101) and c:IsAbleToDeckAsCost()
end
function c22252101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22252101.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>1 end
	local rg=g:RandomSelect(tp,2)
	Duel.SendtoDeck(rg,nil,1,REASON_COST)
end
function c22252101.spfilter(c,e,tp)
	return c:IsCode(22250001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22252101.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22252101.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c22252101.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsExistingMatchingCard(c22252101.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22252101.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end